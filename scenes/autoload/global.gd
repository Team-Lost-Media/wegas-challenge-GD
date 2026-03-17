extends Node

var points: int = 0
var style: String = "none"#the idea is, once style != null itll display it in a style bar like ultrakill and then become null
var style_number: float
var wegadolls_left: int
var max_wegadolls: int
var died_to: String
var died_to_override: String #should be used carefully!!!!!!!!!!
var health: float
var max_health: float = 100

var tutorial = false
var timer_stopped = false

var lap: int = 0
var mode: String = "" #classic for CLASSIC, wcti for THE IDOL,

var credits_cleared: bool = false

signal player_died

#region end screen variables
var time_as_string: String
var time_in_seconds: float

var saved_time_as_string: String = "0:00.000"
#endregion


func reset(): #execited when the player retries after a game over or win
	points = 0
	style = "none"
	wegadoll_combo = 0
	died_to = ""
	died_to_override = ""
	health = 100
	timer_stopped = false

func _ready() -> void:
	add_child(wegadoll_combo_timer)
	wegadoll_combo_timer.timeout.connect(check_wegadoll_combo)

#region wegacombo
var newtimer = Timer
var wegadoll_combo_timer = newtimer.new()
var wegadoll_combo: int = 0
signal wegadoll_collected

func collect_wegadoll() -> void: #executed whenever a wegadoll is collected
	#print("wegadoll")
	
	wegadoll_collected.emit()
	
	wegadoll_combo_timer.one_shot = true
	var timeleft = wegadoll_combo_timer.time_left
	wegadoll_combo_timer.wait_time = 0.35 + (timeleft / 2)
	print(wegadoll_combo_timer.wait_time)
	
	
	
	
	
	if wegadoll_combo_timer.is_stopped():
		wegadoll_combo_timer.stop()
		wegadoll_combo_timer.start()
		wegadoll_combo = 1
	else:
		wegadoll_combo_timer.stop()
		wegadoll_combo_timer.start()
		wegadoll_combo += 1


func check_wegadoll_combo() -> void:
	if wegadoll_combo > 16:
		if wegadoll_combo > 99:
			style = "+ULTRAWEGACOMBO"
			points += 2500
			StyleSFX.play_style_sfx(6)
			Achievements.award("ULTRAWEGACOMBO")
		else:
			style = str("+WEGACOMBO ", wegadoll_combo, "X")
			points += 9 * wegadoll_combo * max(1, wegadoll_combo / 40)
			StyleSFX.play_style_sfx(0, true)
		print(str("+WEGACOMBO ", wegadoll_combo, "X"))
	wegadoll_combo = 0
#endregion

## Requires [code]delta[/code] and [code]x[/code] as parameters. Returns [code]true[/code] when [code]x[/code] seconds have passed. Can be used with any interval, namely multiples of 10 such as 0.01, 0.1 and 1.
func x_seconds_passed(delta: float, x: float):
	var previous_time_in_seconds: int
	var time: float
	previous_time_in_seconds = snapped(time, x)
	time += delta
	
	if snapped(time, x) > previous_time_in_seconds:
		return true
	else:
		return false

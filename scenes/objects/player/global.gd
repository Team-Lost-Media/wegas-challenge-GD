extends Node

var points: int = 0
var style: String = "none"#the idea is, once style != null itll display it in a style bar like ultrakill and then become null



func one_centisecond_passed() -> void:
	pass #print("test")


var timer = Timer
var wegadoll_combo_timer = timer.new()
var wegadoll_combo: int = 0
signal wegadoll_collected


func collect_wegadoll() -> void: #executed whenever a wegadoll is collected
	print("wegadoll")
	
	wegadoll_collected.emit()
	
	wegadoll_combo_timer.one_shot = true
	wegadoll_combo_timer.wait_time = 0.4
	
	
	add_child(wegadoll_combo_timer)
	wegadoll_combo_timer.timeout.connect(check_wegadoll_combo)
	
	if wegadoll_combo_timer.is_stopped():
		wegadoll_combo_timer.stop()
		wegadoll_combo_timer.start()
		wegadoll_combo = 1
		print("a")
	else:
		wegadoll_combo_timer.stop()
		wegadoll_combo_timer.start()
		wegadoll_combo += 1


func check_wegadoll_combo() -> void:
	print("TIMEOUT")
	if wegadoll_combo > 6:
		if wegadoll_combo > 99:
			style = "+ULTRAWEGACOMBO"
			points += 2500
		else:
			style = str("+WEGACOMBO ", wegadoll_combo, "X")
			points += 9 * wegadoll_combo * max(1, wegadoll_combo / 40)
		print(str("+WEGACOMBO ", wegadoll_combo, "X"))
	wegadoll_combo = 0

func _process(delta: float) -> void:
	pass

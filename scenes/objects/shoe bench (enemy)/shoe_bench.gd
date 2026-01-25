extends Sprite3D

#note: this code is reused from wega so itll have a lot of things that arent used

## The node whose position Shoe Bench will move towards.
@export var playerpos: Node3D
## The speed at which Shoe Bench will move towards the player. Shoe Bench is meant to be a killscreen, so this value should be very high.
@export var speed: float
## If set to [code]false[/code], Shoe Bench cannot kill the player. True by default.
@export var kill = true
## The scene to bring the player to if Shoe Bench kills them.
@export var death_scene = "res://scenes/menus/wcti_gameover/shoe bench gameover.tscn"

@onready var start_timer: Timer = $StartTimer
@onready var juke_timer: Timer = $JukeTimer
@onready var enrage_color_timer: Timer = $EnrageColorTimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var enabled = false #if false, shoe bench doesnt move and cant be styled on
var juke_speed_multiplier: float = 1.0 #handles slowdown when juked
var max_wegadolls: int #the amount of wegadolls in the scene when _ready() happens
var wegadoll_percentage: float = 1.0 #pretty self explanatory
var status: String = "" #multi-use status for stuff like debuffs

func _process(delta: float) -> void:
	if enabled:
		#move
		global_position = global_position.move_toward(playerpos.global_position + Vector3(0, 0.6, 0), delta * speed * juke_speed_multiplier)
		
		#shoe bench
		if not audio.playing:
			audio.play()
		
			
		
		#handle slowdown when styled on
		if status == "BENCH":
			if juke_speed_multiplier < 1:
				juke_speed_multiplier = lerp(juke_speed_multiplier, 1.0, 0.8 * delta)
				#print("juke speed multiplier = ", juke_speed_multiplier)
			else:
				juke_speed_multiplier = 1
				status = ""

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			Global.died_to = "shoe bench"
			Global.player_died.emit()
			get_tree().change_scene_to_file(death_scene)

func _on_above_wega_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled:
			juke_speed_multiplier = 0.2
			status = "BENCH"
			Global.points += 1600
			Global.style = "+SHOE BENCH"
			Global.health += 1600/20#handlestylehealthregen
			print("SHOE BENCH")
			Achievements.award("shoe bench")
			StyleSFX.play_style_sfx()

func _on_juke_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled and !body.just_dashed.is_stopped() and juke_timer.is_stopped():
			juke_timer.start()
			juke_speed_multiplier = 0.2
			status = "BENCH"
			Global.points += 1200
			Global.style = "+SHOE BENCH"
			Global.health += 1200/20#handlestylehealthregen
			print("SHOE BENCH")
			StyleSFX.play_style_sfx()

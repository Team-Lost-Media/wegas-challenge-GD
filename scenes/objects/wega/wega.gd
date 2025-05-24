extends Sprite3D

@export var playerpos: CharacterBody3D
@export var speed: float
@export var time_to_enable: float = 3
@export var enable_manually = false
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var speed_up_with_wegadolls = false
@export var percentage_wegadolls_left_to_speed_curve: Curve
@onready var start_timer: Timer = $StartTimer
@onready var juke_timer: Timer = $JukeTimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var enabled = false
var juke_speed_multiplier: float = 1.0
var wegadoll_speed_multiplier: float = 1.0
var max_wegadolls: int
var wegadoll_percentage: float = 1.0
var status: String = ""

func _ready() -> void:
	start_timer.wait_time = time_to_enable
	start_timer.start()
	if enable_manually == true:
		pass

func _process(delta: float) -> void:
	if enabled:
		#move
		global_position = global_position.move_toward(playerpos.global_position + Vector3(0, 0.6, 0), delta * speed * juke_speed_multiplier * wegadoll_speed_multiplier)
		
		#BWAAAAUGH
		if not audio.playing:
			audio.play()
		
		#handle speedup with less wegadolls
		if speed_up_with_wegadolls:
			if Global.max_wegadolls != 0:
				wegadoll_percentage =  float(Global.wegadolls_left) / float(Global.max_wegadolls)
			print("wegadolls_left = ", Global.wegadolls_left)
			print("max_wegadolls = ", Global.max_wegadolls)
			print("wegadoll_percentage = ", wegadoll_percentage)
			wegadoll_speed_multiplier = percentage_wegadolls_left_to_speed_curve.sample(wegadoll_percentage)
			print("wegadoll_speed_multiplier = ", wegadoll_speed_multiplier)
		
		#handle slowdown when juked
		if status == "JUKED":
			if juke_speed_multiplier < 0.8:
				juke_speed_multiplier = lerp(juke_speed_multiplier, 1.0, 0.8 * delta)
				print(juke_speed_multiplier)
			else:
				juke_speed_multiplier = 1
				status = ""

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true
	else:
		pass


func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		get_tree().change_scene_to_file(death_scene)


func _on_above_wega_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled:
			Global.points += 200
			Global.style = "+ABOVE"
			print("ABOVE")

func _on_juke_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled and body.just_dashed.is_stopped() == false and juke_timer.is_stopped():
			juke_timer.start()
			juke_speed_multiplier = 0.5
			status = "JUKED"
			Global.points += 400
			Global.style = "+JUKED"
			print("JUKED")

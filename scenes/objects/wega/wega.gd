extends Sprite3D

@export var playerpos: CharacterBody3D
@export var speed: float
@onready var start_timer: Timer = $StartTimer
@onready var juke_timer: Timer = $JukeTimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var enabled = false

func _ready() -> void:
	start_timer.start()

func _process(delta: float) -> void:
	if enabled:
		global_position = global_position.move_toward(playerpos.global_position, delta * speed)
		if not audio.playing:
			audio.play()

func _on_start_timer_timeout() -> void:
	enabled = true


func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		get_tree().change_scene_to_file("res://scenes/menus/gameover/gameover.tscn")


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
			Global.points += 400
			Global.style = "+JUKED"
			print("JUKED")

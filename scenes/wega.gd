extends Sprite3D

@export var playerpos: CharacterBody3D
@export var speed = 5
@onready var start_timer: Timer = $StartTimer
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


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		get_tree().change_scene_to_file("res://scenes/menus/gameover.tscn")

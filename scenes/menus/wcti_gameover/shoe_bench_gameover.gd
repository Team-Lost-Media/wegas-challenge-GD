extends Node2D

@onready var you_died_to: Label = $"Label/you died to"
@onready var tips: Label = $Label/tips

func _ready() -> void:
	Engine.time_scale = 1.0
	StyleSFX.stop()

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")
		Global.reset()

extends Control

func _ready() -> void:
	Engine.time_scale = 1.0
	StyleSFX.stop()

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/levels/main/mastermode credits test.tscn")
		Global.reset()
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

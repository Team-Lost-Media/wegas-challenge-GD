extends Node2D

## literally just copied from gameover.gd smh

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")

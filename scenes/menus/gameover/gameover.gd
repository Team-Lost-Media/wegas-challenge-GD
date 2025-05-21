extends Node2D


func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		if Global.tutorial == true:
			get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
			Global.reset()
		else:
			get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")
			Global.reset()

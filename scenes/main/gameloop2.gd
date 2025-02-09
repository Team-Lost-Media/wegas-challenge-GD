extends Node3D

@onready var group_of_wegas: Node3D = $"group of wegas"

func _process(delta: float) -> void:
	var wegasleft = group_of_wegas.get_child_count()
	if wegasleft == 0:
		get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn")

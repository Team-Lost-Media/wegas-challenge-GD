extends Node3D

@onready var group_of_wegas: Node3D = $"group of wegas"
@onready var label: Label = $GUI/Label

func _process(delta: float) -> void:
	var wegasleft = group_of_wegas.get_child_count()
	label.text = "wegas left: %s" % wegasleft
	if wegasleft == 0:
		get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn")

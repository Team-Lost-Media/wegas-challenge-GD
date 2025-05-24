extends Area3D

@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		get_tree().change_scene_to_file(death_scene)

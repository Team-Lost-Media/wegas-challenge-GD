extends Control

func _on_reset_button_pressed() -> void:
	Save.reset_everything()
	get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")

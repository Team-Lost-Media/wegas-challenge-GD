extends Control

func _ready() -> void:
	pass
	#SongCredits.stop or something idk


func _on_reset_button_pressed() -> void:
	Save.reset_everything()
	get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

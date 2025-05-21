extends Control

## Wega's Challenge Godot Port

## most of the code here was stolen from a first person template lmao

@onready var settings = $Settings
@onready var buttons = $VBoxContainer



func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")

func _tutorial() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
	Global.tutorial = true


func _settings() -> void:
	settings.show()
	buttons.hide()

func _quit() -> void:
	self.get_tree().quit()

func _on_close_button() -> void:
	settings.hide()
	buttons.show() 

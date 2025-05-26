extends Control

## Wega's Challenge Godot Port

## most of the code here was stolen from a first person template lmao

@onready var settings = $Settings
@onready var buttons = $VBoxContainer
@onready var tips = $tips


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


var list = []   
var list_position = 0

func _ready() -> void:
	var path = ""
	#if OS.has_feature("editor"):
	#	path = ProjectSettings.globalize_path("res://Text/flavortext.txt")
	#else:
	#	path = OS.get_executable_path().get_base_dir().path_join("data/text/pause/flavortext.txt")
	
	path = "res://assets/other/tips.txt"
	
	var f = FileAccess.open(path, FileAccess.READ)
	
	while not f.eof_reached():
		list.append(f.get_line())
	
	list.shuffle()
	var random_item = random_item()
	while random_item == "":
		random_item = random_item()
	if random_item != "":
		tips.text = random_item

func random_item():
	list_position+=1

	if list_position == list.size():
		list.shuffle()
		list_position = 0

	return list[list_position]

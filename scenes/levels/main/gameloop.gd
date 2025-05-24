extends Node3D

@onready var group_of_wegas: Node3D = $"group of wegas"
@onready var label: Label = $GUI/Label
@onready var sfx: AudioStreamPlayer = $SFX

@onready var wegasleft = group_of_wegas.get_child_count()

func _ready() -> void:
	Global.points = 0
	Global.style = "none"

func _process(delta: float) -> void:
	if wegasleft != group_of_wegas.get_child_count():
		sfx.play()
	wegasleft = group_of_wegas.get_child_count()
	label.text = "wegas left: %s" % wegasleft
	if wegasleft == 0:
		#get_tree().change_scene_to_file("res://scenes/levels/main/main2.tscn") #go to main2
		get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn") #win
		
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

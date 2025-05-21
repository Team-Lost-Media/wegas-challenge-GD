extends Node3D

@onready var wega = $Wega
@onready var wega_labels = $Main/Labels/WegaLabels
@onready var music = $AudioStreamPlayer
@onready var sun = $Main/DirectionalLight3D
@onready var wegagridmap = $Main/WegaGridMap
@onready var player = $Player

var increase_sun = false

@onready var group_of_wegas = $"group of wegas"
@onready var wegasleft = group_of_wegas.get_child_count()
@onready var sfx = $SFX

func _ready() -> void:
	player.style_panel.hide()
	wega.hide()
	wega_labels.hide()
	wegagridmap.hide()
	Global.points = 0
	Global.style = "none"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Global.tutorial = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if increase_sun == true:
		sun.light_energy = lerp(sun.light_energy, 5.0, 0.4 * delta)
		sun.light_color = sun.light_color.lerp(Color(1, 0, 0.5), 0.4 * delta)
		print(sun.light_color)
	
	if wegasleft != group_of_wegas.get_child_count():
		sfx.play()
	wegasleft = group_of_wegas.get_child_count()
	if wegasleft == 0:
		get_tree().change_scene_to_file("res://scenes/menus/win/tutorial win.tscn")


func _on_wegadoll_collected() -> void: #this only applies to the first one dw
	wega_labels.show()
	player.style_panel.show()
	wega.show()
	wega.enabled = true
	wegagridmap.show()
	wegagridmap.collision_layer = 1
	increase_sun = true
	music.play()

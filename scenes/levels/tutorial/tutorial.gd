extends Node3D

@onready var wega = $Wega
@onready var wega_labels = $Main/Labels/WegaLabels
@onready var purple_sun_bgm: AudioStreamPlayer = $AudioStreamPlayer
@onready var music: AudioStreamPlayer = $WEXECUTION
@onready var sun = $Main/DirectionalLight3D
@onready var wegagridmap = $Main/WegaGridMap
@onready var player = $Player
@onready var is_the_player_in_the_room: Area3D = $"Main/is the player in the room"

var increase_sun = false

var final_wegadoll_collected = false
var punch_tutorial_initiated = false

@onready var group_of_wegas = $"group of wegas"
@onready var wegasleft = group_of_wegas.get_child_count()
@onready var sfx = $SFX

const WEXECUTION = preload("res://assets/BGM/WEXECUTION.mp3")
@onready var so_retro: Node3D = $"Main/So Retro!"

func _ready() -> void:
	player.style_panel.hide()
	wega.hide()
	wega_labels.hide()
	so_retro.hide()
	wegagridmap.hide()
	StyleSFX.stop()
	Global.points = 0
	Global.style = "none"
	Global.reset()

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
	
	so_retro.rotation.y -= PI * 2 * delta
	
	if wegasleft == 0:
		if final_wegadoll_collected == false:
			player.velocity.y = 60
			player.collision.disabled = true
		final_wegadoll_collected = true
		
		if player.position.y > 35 and punch_tutorial_initiated == false:
			punch_tutorial_initiated = true
			player.collision.disabled = false
			var player_in_room: bool = false
			for body in is_the_player_in_the_room.get_overlapping_bodies():
				if body is PlayerCharacter:
					player_in_room = true
			if !player_in_room: player.position = Vector3(-173.5, 31.521, -4.855)
			player.position.y = 31.521
			#player.velocity.y = 4
			wega.enabled = false
			wega.position.y = -9999999
			so_retro.show()
		
		#get_tree().change_scene_to_file("res://scenes/menus/win/tutorial win.tscn")
		#Global.tutorial = false


func _on_wegadoll_collected() -> void: #this only applies to the first one dw
	wega_labels.show()
	player.style_panel.show()
	wega.show()
	wega.enabled = true
	wegagridmap.show()
	wegagridmap.collision_layer = 1
	increase_sun = true
	purple_sun_bgm.stop()
	music.play()
	SongCredits.show_song_credits("WEXECUTION", "Kiwiquest")


func So_Retro(body: Node3D) -> void:
	if body is PlayerCharacter:
		get_tree().change_scene_to_file("res://scenes/menus/win/tutorial win.tscn")
		Global.tutorial = false

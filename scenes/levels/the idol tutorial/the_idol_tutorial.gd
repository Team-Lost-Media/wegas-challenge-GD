extends Node3D

@onready var wega = $Wega
@onready var purple_sun_bgm: AudioStreamPlayer = $AudioStreamPlayer
@onready var music: AudioStreamPlayer = $WEXECUTION
@onready var sun = $Main/DirectionalLight3D
@onready var player = $Player

@onready var group_of_wegas = $"group of wegas"
@onready var wegasleft = group_of_wegas.get_child_count()
@onready var sfx = $SFX

const WEXECUTION = preload("res://assets/BGM/WEXECUTION.mp3")

func _ready() -> void:
	#player.style_panel.hide()
	wega.hide()
	StyleSFX.stop()
	Global.points = 0
	Global.style = "none"
	Global.reset()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Global.tutorial = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if wegasleft != group_of_wegas.get_child_count():
		sfx.play()
		wegasleft = group_of_wegas.get_child_count()
	
	if wegasleft == 0:
		get_tree().change_scene_to_file("res://scenes/menus/win/wcti tutorial win.tscn")
		Global.tutorial = false



func _on_wegadoll_collected() -> void: #this only applies to the first one dw
	pass
	#player.style_panel.show()
	#wega.show()
	#wega.enabled = true
	#purple_sun_bgm.stop()
	#music.play()
	#SongCredits.show_song_credits("WEXECUTION", "From: Wega's Wadness", "By: Kiwiquest")


'''
Wega is not the only enemy.
Some deal damage. You can heal by doing +STYLE.
If you ever see this symbol, try left clicking.
Good luck.
'''

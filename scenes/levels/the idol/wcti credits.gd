extends Node3D

@onready var group_of_wegas: Node3D = $"Main/GridMap/group of wegas"
@onready var label: Label = $GUI/Label
@onready var sfx: AudioStreamPlayer = $SFX
@onready var grid_map: GridMap = $Main/GridMap
@onready var player: PlayerCharacter = $Player
@onready var credits_parent: Node3D = $"Credits Parent"
@onready var credits: Node3D = $"Credits Parent/Credits"
@onready var bgm: AudioStreamPlayer = $AudioStreamPlayer

@onready var environment: WorldEnvironment = $Main/WorldEnvironment2
@onready var sun: DirectionalLight3D = $Main/DirectionalLight3D
@onready var wega: Sprite3D = $Wega
@onready var maltigi: Sprite3D = $Maltigi

@onready var music_timer: Timer = $"music timer"

var rotating: bool = false

var time: float = 0

func _ready() -> void:
	credits_parent.hide()
	sun.light_energy = 0.2
	environment.environment.sky.sky_material.energy_multiplier = 0.2
	
	wega.kill = false #WEGAKILL?????????
	music_timer.wait_time = 0.3647*2
	
	Global.points = 0
	Global.style = "none"
	Global.mode = "credits"
	Global.timer_stopped = true


func start() -> void:
	bgm.play()
	music_timer.start()
	SongCredits.show_song_credits("Staff Roll", "TGM2 OST")
	
	credits_parent.show()
	
	Global.timer_stopped = false
	
	var tween = create_tween()
	tween.tween_property(sun, "light_energy", 10, 1)
	var tween2 = create_tween()
	tween.tween_property(environment, "environment:sky:sky_material:energy_multiplier", 1, 1)
	
	wega.show()
	wega.kill = true #ok weve done the joke already pack it up go home
	maltigi.show()
	
	await get_tree().create_timer(1.2).timeout
	rotating = true
	await get_tree().create_timer(0.1).timeout
	flash()
	await get_tree().create_timer(2).timeout
	wega.enabled = true
	maltigi.start()
	

func _process(delta: float) -> void:
	if not Global.timer_stopped: time += delta
	if time > 60:
		#Achievements.award("thanks for playing!")
		get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn") #win
		
	credits_parent.rotation.y = player.global_rotation.y + 90 + 45.125
	credits_parent.position = Vector3(player.position.x, credits_parent.position.y, player.position.z)
	#credits_parent.rotation.y *= -1
	print(credits_parent.rotation_degrees.y)
	#print(player.global_rotation_degrees.y)
	#credits_parent.rotate_y(player.global_rotation.y - credits_parent.rotation.y)
	#credits_parent.look_at(player.position)
	if credits.position.y < 440 and rotating: credits.position.y += 7.4 * delta
	
	if rotating: grid_map.rotation.z += 0.33 * delta
	#player.gravity = player.gravity.rotated(Vector3(0, 0, 1), 0.33 * delta)
	#player.gravity = Vector3(0, -30, 0) + (player.gravity.rotated(Vector3(0, 0, 1), 0.33 * delta) * 0.5)
	#player.gravity = Vector3(0, -55, 0) + player.global_position.direction_to(grid_map.global_position)
	
	if bgm.get_playback_position() > 60:
		bgm.queue_free()
	
	#if Input.is_action_just_pressed("attack"): flash()
	
	if Input.is_action_just_pressed("escape"):
		
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func flash() -> void:
	environment.environment.sky.sky_material.sky_horizon_color.r = 0.4
	environment.environment.sky.sky_material.sky_horizon_color.g = 0.1
	environment.environment.sky.sky_material.ground_horizon_color.v = 1.0
	environment.environment.sky.sky_material.ground_bottom_color.v = 0.2
	sun.light_energy += 50
	var horizontween = create_tween()
	horizontween.tween_property(environment, "environment:sky:sky_material:sky_horizon_color:r", 0.01, 1)
	var horizontween2 = create_tween()
	horizontween2.tween_property(environment, "environment:sky:sky_material:sky_horizon_color:g", 0.00, 1)
	var horizontween3 = create_tween()
	horizontween3.tween_property(environment, "environment:sky:sky_material:ground_horizon_color:v", 0.54, 1)
	var horizontween4 = create_tween()
	horizontween4.tween_property(environment, "environment:sky:sky_material:ground_bottom_color:v", 0.06, 1)
	var suntween = create_tween()
	suntween.tween_property(sun, "light_energy", 10, 1)



func _on_wegadoll_collected() -> void:
	start()
	sfx.play()


var music_bars: int = -1
func _on_music_timer_timeout() -> void:
	music_bars += 1
	print(music_bars)
	$Label.text = str(music_bars)
	#16 is when square waves enter
	#32 is the break
	#46 is the segue to the big part
	#48 is the big part
	#64 is the bigger part with extra squarewaves
	#80 is the end 
	#also remember all of these are actually +1 cus of Music but
	if music_bars > 48 and music_bars%2 == 1:
		flash()
	
	

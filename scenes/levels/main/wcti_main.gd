extends Node3D

@onready var group_of_wegas: Node3D = $"group of wegas"
@onready var group_of_wegas_TWO: Node3D = $"group of wegas TWO"
@onready var label: Label = $GUI/Label
@onready var message: Label = $GUI/Message
@onready var sfx: AudioStreamPlayer = $SFX
@onready var wexecution: AudioStreamPlayer = $WEXECUTION
@onready var wegafadence: AudioStreamPlayer = $WEGAFADENCE

@onready var wegasleft = group_of_wegas.get_child_count()

@onready var environment: WorldEnvironment = $Main/WorldEnvironment2
@onready var sun: DirectionalLight3D = $Main/DirectionalLight3D
@onready var skybox: Node3D = $Main/skybox


@onready var so_retro: Node3D = $"So Retro!"
@onready var so_retro_area: Area3D = $"So Retro!/Area3D"
@onready var wega: Sprite3D = $Wega
@onready var maltigi: Sprite3D = $Maltigi
@onready var player: PlayerCharacter = $Player
@onready var wegafadence_beat: RhythmNotifier = $"wegafadence beat" #emits a signal every bar
var wegafadence_bars: int = 0
@onready var gridmap: GridMap = $Main/GridMap
@onready var lap_2_gridmap: GridMap = $Main/Lap2GridMap
@onready var lap_2_start_pause: Timer = $Lap2StartPause
@onready var flash: CanvasLayer = $Flash

@export var so_retro_material: Material
@export var lap2_sun_color: Color

var delta_but_the_one_i_used_for_the_transition_to_lap_2: float
var lap2_startable = false
var move_lap_2_gridmap = false
var lap = 1


func _ready() -> void:
	Global.points = 0
	Global.style = "none"
	Global.wegadolls_left = wegasleft
	Global.max_wegadolls = wegasleft
	wegafadence_beat.running = false
	message.text = ""
	maltigi.stop()
	lap_2_gridmap.position.y = -30
	lap_2_gridmap.hide()
	group_of_wegas_TWO.position.y = -30
	group_of_wegas_TWO.hide()
	gridmap.mesh_library.get_item_mesh(2).surface_set_material(0, gridmap.mesh_library.get_item_mesh(0).surface_get_material(0))
	#flash.flash(Color.WHITE, 1.5)


var wega_started: bool = false
var rorys_started: bool = false
var maltigi_started: bool = false
var lap1exit_started: bool = false

func _process(delta: float) -> void:
	delta_but_the_one_i_used_for_the_transition_to_lap_2 = delta
	
	if lap == 1:
		if wegasleft != group_of_wegas.get_child_count():
			sfx.play()
			Global.wegadolls_left = group_of_wegas.get_child_count()
		wegasleft = group_of_wegas.get_child_count()
		label.text = "wegas left: %s" % wegasleft
	elif lap == 2:
		if wegasleft != group_of_wegas_TWO.get_child_count():
			sfx.play()
			Global.wegadolls_left = group_of_wegas_TWO.get_child_count()
		wegasleft = group_of_wegas_TWO.get_child_count()
		label.text = "wegas left: %s" % wegasleft
	
	if wegasleft <= 100:
		if maltigi_started == false:
			maltigi.start(true)
			message.say("MALTIGI IS COMING")
			maltigi_started = true
	
	
	if wegasleft <= 50:
		if wega_started == false:
			message.say("WEGA IS ENRAGED")
			wega_started = true
	
	if wegasleft <= 150 and lap != 2:
		lap1exit_started = true
		lap2_startable = true
		so_retro.show()
		wega.enabled = false
		wega.kill = false
		wega.position.y = -100.0
		wega.speed = 0.0
		wega.hide()
		maltigi.enabled = false
		maltigi.kill = false
		maltigi.hide()
		Global.timer_stopped = true
		player.fade_out_gui(delta)
		label.modulate = label.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
		wexecution.pitch_scale = lerp(wexecution.pitch_scale, 0.5, clamp(0.6 * delta, 0.0, 1.0))
		wexecution.volume_linear = lerp(wexecution.volume_linear, 0.0, clamp(0.6 * delta, 0.0, 1.0))
	
	if lap == 2:
		lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0.0, clamp(5.0 * delta, 0.0, 1.0))
		group_of_wegas_TWO.position.y = lerp(group_of_wegas_TWO.position.y, 1.0, clamp(5.0 * delta, 0.0, 1.0))
		sun.light_color = sun.light_color.lerp(lap2_sun_color, clamp(1.5 * delta, 0.0, 1.0))
	
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	so_retro.rotation.y -= PI * 2 * delta


func _on_so_retro_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and lap2_startable == true:
		lap = 2
		wexecution.stop()
		Global.timer_stopped = false
		so_retro.position.y -= 200
		so_retro.hide()
		label.modulate = Color.WHITE
		player.style_panel.modulate = Color.WHITE
		player.superjump_cooldown_bar.modulate = Color.WHITE
		player.dash_cooldown_bar.modulate = Color.WHITE
		
		#change to lap 2
		#blahblahblah idk how ill do this lmao ill figure something out
		lap_2_gridmap.show()
		group_of_wegas_TWO.show()
		#lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0.0, clamp(5.0 * delta_but_the_one_i_used_for_the_transition_to_lap_2, 0.0, 1.0))
		lap_2_start_pause.start()
		
		#currently used as a placeholder
		#get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn") #win


func _on_rhythm_notifier_beat(current_beat: int) -> void:
	wegafadence_bars += 1
	sfx.play()
	match wegafadence_bars:
		16:
			flash.flash(Color.WHITE, 1.5)
		32:
			flash.flash(Color.INDIAN_RED, 1.5)
			skybox.show()


func _on_lap_2_start_pause_timeout() -> void:
	wegafadence.play()
	flash.flash(Color.WHITE, 1.5)
	gridmap.mesh_library.get_item_mesh(0).surface_set_material(0, so_retro_material)
	gridmap.mesh_library.get_item_mesh(1).surface_set_material(0, so_retro_material)
	gridmap.mesh_library.get_item_mesh(2).surface_set_material(0, so_retro_material)

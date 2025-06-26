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
@onready var particles: CPUParticles3D = $particles


@onready var so_retro: Node3D = $"So Retro!"
@onready var so_retro_area: Area3D = $"So Retro!/Area3D"
@onready var wega: Sprite3D = $Wega
@onready var maltigi: Sprite3D = $Maltigi
@onready var rorys: AnimatedSprite3D = $Rorys
@onready var ultra_irios: Sprite3D = $"Ultra Irios"

#the three benches
@onready var shoe_bench_timer: Control = $"Shoe Bench Timer"
@onready var you_have_3_minutes_left_to_live: Label = $"Shoe Bench Timer/YOU HAVE 3 MINUTES LEFT TO LIVE"
@onready var bench_bar: ProgressBar = $"Shoe Bench Timer/BenchBar"
@onready var the_man_himself: Sprite2D = $"Shoe Bench Timer/the man himself"

@onready var player: PlayerCharacter = $Player
@onready var wegafadence_beat: RhythmNotifier = $"wegafadence beat" #emits a signal every bar
var wegafadence_bars: int = 0
@onready var gridmap: GridMap = $Main/GridMap
@onready var lap_2_gridmap: GridMap = $Main/Lap2GridMap
@onready var the_idol_gridmap: GridMap = $"Main/The Idol GridMap"
@onready var lap_2_start_pause: Timer = $Lap2StartPause
@onready var flash: CanvasLayer = $Flash
@onready var the_retros: MeshInstance3D = $"the retros"


@export var so_retro_material: Material
@export var lap2_sun_color: Color
@export var lap2_sky: ProceduralSkyMaterial
@export var hot_particles: Mesh

var delta_but_the_one_i_used_for_the_transition_to_lap_2: float
var lap1_sky: Sky
var lap2_startable = false
var move_lap_2_gridmap = false
var lap = 1
var lap_2_sun_fadeout = false
var shoe_bench_timer_slide_in = false

var shoe_bench_scale: Vector2
func _ready() -> void:
	Global.points = 0
	Global.style = "none"
	Global.wegadolls_left = wegasleft
	Global.max_wegadolls = wegasleft
	shoe_bench_timer.position.y += 200
	wegafadence_beat.running = false
	wegafadence_bars = 0
	lap1_sky = environment.environment.sky
	message.text = ""
	maltigi.stop()
	shoe_bench_scale = the_man_himself.scale
	lap_2_gridmap.position.y = -30
	lap_2_gridmap.hide()
	group_of_wegas_TWO.position.y = -30
	group_of_wegas_TWO.hide()
	the_idol_gridmap.position.y = -50
	the_idol_gridmap.hide()
	
	gridmap.mesh_library.get_item_mesh(2).surface_set_material(0, gridmap.mesh_library.get_item_mesh(0).surface_get_material(0))
	#flash.flash(Color.WHITE, 1.5)

var time_passed = 0.0

var wega_started: bool = false
var rorys_started: bool = false
var maltigi_started: bool = false
var lap1exit_started: bool = false
var the_idol_outro_started: bool = false
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
	
	if wegasleft <= 150  and lap == 1:
		if rorys_started == false:
			rorys.enabled = true
			message.say("PUNCH RORYS", 2.0)
			rorys_started = true
	
	if wegasleft <= 100  and lap == 1:
		if maltigi_started == false:
			maltigi.start(true)
			message.say("MALTIGI IS COMING", 2.0)
			maltigi_started = true
	
	
	if wegasleft <= 50  and lap == 1:
		if wega_started == false:
			message.say("WEGA IS ENRAGED", 2.0)
			wega_started = true
	
	if wegasleft <= 0 and lap == 1:
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
		rorys.enabled = false
		rorys.position.y = -100
		rorys.hide()
		Global.timer_stopped = true
		player.fade_out_gui(delta)
		label.modulate = label.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
		wexecution.pitch_scale = lerp(wexecution.pitch_scale, 0.5, clamp(0.6 * delta, 0.0, 1.0))
		wexecution.volume_linear = lerp(wexecution.volume_linear, 0.0, clamp(0.6 * delta, 0.0, 1.0))
	
	if lap == 2:
		maltigi.enabled = false
		lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0.0, clamp(5.0 * delta, 0.0, 1.0))
		group_of_wegas_TWO.position.y = lerp(group_of_wegas_TWO.position.y, 1.0, clamp(5.0 * delta, 0.0, 1.0))
		if FUCK == false:
			sun.light_color = sun.light_color.lerp(lap2_sun_color, clamp(1.5 * delta, 0.0, 1.0))
		
		#if wegasleft <= 
		
		
		
		if wegasleft <= 0:
			the_idol_gridmap.position.y = lerp(the_idol_gridmap.position.y, 0.0, clamp(5.0 * delta, 0.0, 1.0))
			if the_idol_outro_started == false:
				the_idol_gridmap.show()
				message.say("GET THE IDOL", 2.0)
				the_idol_outro_started = true
			
		
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if wegafadence.playing:
		
		time_passed += delta
		var time_left = abs(snapped(time_passed - 170.0, 0.1))
		var minutes = snapped(time_left, 60) / 60
		you_have_3_minutes_left_to_live.text = str(time_left)
		#you_have_3_minutes_left_to_live.text = str(minutes, ":", time_left - minutes * 60) 
	
	so_retro.rotation.y -= PI * 2 * delta
	the_retros.rotation.y -= PI * 0.1 * delta
	
	if shoe_bench_timer_slide_in == true:
		var tween = create_tween()
		tween.tween_property(shoe_bench_timer, "position", Vector2(0, 0), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	


func _on_so_retro_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and lap2_startable == true:
		lap = 2
		wexecution.stop()
		Global.timer_stopped = false
		so_retro.position.y -= 200
		so_retro.hide()
		message.say("IT'S RETRO TIME", 10.0)
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

var FUCK = false
var shit: Mesh
func _on_rhythm_notifier_beat(current_beat: int) -> void:
	wegafadence_bars += 1
	bench_bar.value = wegafadence_bars
	shoe_bench_timer_bounce()
	print(wegafadence_bars)
	#sfx.play()
	
	match wegafadence_bars:
		16:
			flash.flash(Color.WHITE, 1.5)
			particles.emitting = true
			shit = particles.mesh
		32:
			FUCK = true
			sun.light_color = Color.from_string("e02e16", Color.CHARTREUSE)
			flash.flash(Color.INDIAN_RED, 1.5)
			skybox.show()
			particles.mesh = hot_particles
		48:
			flash.flash(Color.WHITE, 1.5)
			skybox.hide()
			particles.mesh = shit
			sun.light_color = Color.from_rgba8(123, 22, 224)
			sun.light_energy = 4.0
			environment.environment.sky = lap1_sky
		62:
			FUCK = false
		64:
			environment.environment.sky.sky_material = lap2_sky
			flash.flash(Color.WHITE, 1.5)
			sun.light_energy = 12.0
			the_retros.show()
		96:
			FUCK = true
			sun.light_color = Color.from_string("e02e16", Color.CHARTREUSE)
			flash.flash(Color.INDIAN_RED, 1.5)
			skybox.show()
			particles.mesh = hot_particles

func _on_lap_2_start_pause_timeout() -> void:
	wegafadence.play()
	message.stop()
	flash.flash(Color.WHITE, 1.5)
	environment.environment.sky.sky_material = lap2_sky
	gridmap.mesh_library.get_item_mesh(0).surface_set_material(0, so_retro_material)
	gridmap.mesh_library.get_item_mesh(1).surface_set_material(0, so_retro_material)
	gridmap.mesh_library.get_item_mesh(2).surface_set_material(0, so_retro_material)
	shoe_bench_timer_slide_in = true
	ultra_irios.enabled = true
	ultra_irios.cooldown_timer.start(ultra_irios.cooldown)
	ultra_irios.show()

func shoe_bench_timer_bounce() -> void:
	if snapped(wegafadence_bars / 2.0, 1) == wegafadence_bars / 2.0: #if it's even then
		bounce(the_man_himself, Vector2(0.7, 1.3) * shoe_bench_scale, Vector2(1.0, 1.0) * shoe_bench_scale)
	else: #if it's odd then
		bounce(the_man_himself, Vector2(1.3, 0.7) * shoe_bench_scale, Vector2(1.0, 1.0) * shoe_bench_scale)

## Makes the given node bounce. The node MUST have its pivot centered, and it MUST have a transform and scale property!
func bounce(node: Node, start: Vector2 = Vector2(0.9, 1.1), end: Vector2 = Vector2(1.0, 1.0)) -> void:
	var tween = create_tween()
	tween.tween_property(node, "scale", start, 0.05).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", end, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

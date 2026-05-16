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
@onready var shoe_bench: Sprite3D = $"Shoe Bench"
@onready var super_john: CharacterBody3D = $SuperJohn
@onready var glitchigi: Sprite3D = $Glitchigi

#the three benches
@onready var shoe_bench_timer: Control = $"Shoe Bench Timer"
@onready var you_have_3_minutes_left_to_live: Label = $"Shoe Bench Timer/YOU HAVE 3 MINUTES LEFT TO LIVE"
@onready var bench_bar: ProgressBar = $"Shoe Bench Timer/BenchBar"
@onready var the_man_himself: Sprite2D = $"Shoe Bench Timer/the man himself"

@onready var player: PlayerCharacter = $Player
var wegafadence_bars: int = 0
@onready var gridmap: GridMap = $Main/GridMap
@onready var lap_2_gridmap: GridMap = $Main/Lap2GridMap
@onready var the_idol_gridmap: GridMap = $"Main/The Idol GridMap"
@onready var lap_2_start_pause: Timer = $Lap2StartPause
@onready var flash: CanvasLayer = $Flash
@onready var the_retros: MeshInstance3D = $"the retros"
@onready var wegafadence_beat_timer: Timer = $"wegafadence beat"

@export var so_retro_material: Material
@export var lap2_sun_color: Color
@export var lap2_sky: ProceduralSkyMaterial
@export var hot_particles: Mesh
@export var shoe_bench_murder_mode: Texture2D

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
	Global.mode = "wcti"
	SongCredits.show_song_credits("WEXECUTION", "From: Wega's Wadness", "By: Kiwiquest")
	shoe_bench_timer.position.y += 600
	wegafadence_bars = 0
	lap1_sky = environment.environment.sky
	message.text = ""
	maltigi.stop()
	glitchigi.stop()
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
var time_left: float

var wega_started: bool = false
var rorys_started: bool = false
var maltigi_started: bool = false
var lap1exit_started: bool = false
var rorys2_started: bool = false
var john_started: bool = false
var glitchigi_started: bool = false
var the_idol_outro_started: bool = false
var FUCK2: bool
func _process(delta: float) -> void:
	delta_but_the_one_i_used_for_the_transition_to_lap_2 = delta
	
	Global.lap = lap
	
	if lap == 1:
		if wegasleft != group_of_wegas.get_child_count():
			sfx.play()
			Global.wegadolls_left = group_of_wegas.get_child_count()
		wegasleft = group_of_wegas.get_child_count()
		label.text = "--" + str(wegasleft) + "--"
	elif lap == 2:
		if wegasleft != group_of_wegas_TWO.get_child_count():
			sfx.play()
			Global.wegadolls_left = group_of_wegas_TWO.get_child_count()
		wegasleft = group_of_wegas_TWO.get_child_count()
		label.text = "--" + str(wegasleft) + "--"
	
	if wegasleft <= 150 and lap == 1:
		if rorys_started == false:
			rorys.enabled = true
			message.say("RORYS IS COMING", 2.0)
			rorys_started = true
	
	if wegasleft <= 100  and lap == 1:
		if maltigi_started == false:
			maltigi.start(true)
			message.say("MALTIGI IS COMING", 2.0)
			maltigi_started = true
	
	
	if wegasleft <= 50 and lap == 1:
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
		player.heal_health = false
		label.modulate = label.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
		wexecution.pitch_scale = lerp(wexecution.pitch_scale, 0.5, clamp(0.6 * delta, 0.0, 1.0))
		wexecution.volume_linear = lerp(wexecution.volume_linear, 0.0, clamp(0.6 * delta, 0.0, 1.0))
		Achievements.award("WEXECUTION")
	
	if lap == 2:
		maltigi.enabled = false
		lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0.0, clamp(5.0 * delta, 0.0, 1.0))
		group_of_wegas_TWO.position.y = lerp(group_of_wegas_TWO.position.y, 1.0, clamp(5.0 * delta, 0.0, 1.0))
		if FUCK == false:
			sun.light_color = sun.light_color.lerp(lap2_sun_color, clamp(1.5 * delta, 0.0, 1.0))
		
		if wegasleft <= 300:
			if rorys2_started == false:
				message.say("RORYS IS COMING")
				rorys.group_of_wegas = self.group_of_wegas_TWO
				rorys.enabled = true
				rorys.stay_still_time = 8
				rorys2_started = true
		
		if wegasleft <= 250:
			if john_started == false:
				message.say("SUPER JOHN IS COMING")
				super_john.position = player.position + Vector3(0, 0, 30)
				super_john.show()
				super_john.enabled = true
				john_started = true
		
		if wegasleft <= 200:
			if glitchigi_started == false:
				message.say("MALTIGI IS COMING")
				glitchigi.start(true)
				glitchigi_started = true
		
		if wegasleft <= 0:
			the_idol_gridmap.position.y = lerp(the_idol_gridmap.position.y, 0.0, clamp(5.0 * delta, 0.0, 1.0))
			if the_idol_outro_started == false:
				the_idol_gridmap.show()
				message.say("GET THE IDOL", 2.0)
				the_idol_outro_started = true
			
		
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#region shoe bench timer
	if wegafadence.playing:
		time_passed += delta
		if FUCK2 == false: time_left = abs(snapped(time_passed - 170.0, 0.1))
		print(time_left)
		if time_left > 0:
			if FUCK2 == false:
				you_have_3_minutes_left_to_live.text = str(time_left)
		else:
			FUCK2 = true
			time_left = 1
			you_have_3_minutes_left_to_live.text = "youre gna die"
			the_man_himself.texture = shoe_bench_murder_mode
			var tween = create_tween()
			tween.tween_property(the_man_himself, "position", Vector2(the_man_himself.position.x, 1400), 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			shoe_bench_is_going_to_fucking_murder_you()
	
	if shoe_bench_timer_slide_in == true:
		var tween = create_tween()
		tween.tween_property(shoe_bench_timer, "position", Vector2(0, 0), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#endregion
	
	so_retro.rotation.y -= PI * 2 * delta
	the_retros.rotation.y -= PI * 0.1 * delta

func _on_so_retro_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and lap2_startable == true:
		
		#comment this out for lap 2
		#if not Global.do_lap_2: get_tree().change_scene_to_file("res://scenes/menus/wcti_win/wcti_win.tscn") #win
		
		#change to lap 2
		lap = 2
		wexecution.stop()
		Global.timer_stopped = false
		so_retro.position.y -= 200
		so_retro.hide()
		message.say("IT'S RETRO TIME", 10.0)
		label.modulate = Color.WHITE
		
		player.style_panel.modulate = Color.WHITE
		player.super_jump_cooldown_bar_outline.modulate = Color.WHITE
		player.superjump_cooldown_bar.modulate = Color.WHITE
		player.dash_cooldown_bar_outline.modulate = Color.WHITE
		player.dash_cooldown_bar.modulate = Color.WHITE
		player.heal_health = true
		
		lap_2_gridmap.show()
		group_of_wegas_TWO.show()
		#lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0.0, clamp(5.0 * delta_but_the_one_i_used_for_the_transition_to_lap_2, 0.0, 1.0))
		lap_2_start_pause.start()
		

func wassup_guys_its_me_the_idol(body: Node3D) -> void:
	if body is PlayerCharacter:
		Achievements.award("WEGAFADENCE")
		Global.saved_time_as_string = Global.time_as_string
		get_tree().change_scene_to_file("res://scenes/menus/wcti_win/wcti_win.tscn") #win


var FUCK = false
var shit: Mesh
func _on_wegafadence_beat() -> void:
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
		112:
			flash.flash(Color.WHITE, 1.5)
			skybox.hide()
			the_retros.hide()
			particles.mesh = shit
			FUCK = true
			sun.light_color = Color.from_rgba8(123, 22, 224)
			sun.light_energy = 4.0
			environment.environment.sky = lap1_sky
		128:
			flash.flash(Color.WHITE, 1.5)
			sun.light_color = Color.BLACK
			particles.emitting = false
			#ultra_irios.playerpos = ultra_irios.position + Vector3(0, 100, 0)

func _on_lap_2_start_pause_timeout() -> void:
	wegafadence.play()
	wegafadence_beat_timer.start()
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
	lap = 2
	
	SongCredits.show_song_credits("WEGAFADENCE", "From: WC:TI OST", "By: GAMR")

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

func shoe_bench_is_going_to_fucking_murder_you() -> void:
	await get_tree().create_timer(1.0).timeout
	shoe_bench.show()
	shoe_bench.enabled = true
	shoe_bench.position.y = 0

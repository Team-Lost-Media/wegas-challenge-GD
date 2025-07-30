extends AnimatedSprite3D

@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var kill = false
@export var piss_off = true
@export var enable_manually = false
@export var group_of_wegas: Node3D
@export var time_to_enable: float = 0.0
@export var stay_still_time: float = 5.0
@export var targeted_wegadoll_material: StandardMaterial3D
@export var player: PlayerCharacter
@export var punch_sfx: AudioStream
@export var explosion_sfx: AudioStream
@export var flash: CanvasLayer
@export var damage: float = 70

@onready var stay_still_timer: Timer = $StayStillTimer
@onready var start_timer: Timer = $StartTimer
@onready var hitstop: Timer = $Hitstop
@onready var sfx: AudioStreamPlayer = $SFX
@onready var piss_off_sfx: AudioStreamPlayer = $PissOffSFX
@onready var stun_timer: Timer = $StunTimer
@onready var rory: Sprite2D = $rory
@onready var piss_off_timer: Timer = $PissOffTimer
@onready var death_area: Area3D = $DeathArea3D

var enabled = false
var punchable = false 
var wegadoll: Node3D
var normal_wegadoll_material: StandardMaterial3D

func _ready() -> void:
	start_timer.wait_time = time_to_enable
	start_timer.start()
	play("default")
	if enable_manually == true:
		pass

func _process(delta: float) -> void:
	if enabled:
		if stay_still_timer.is_stopped() and stun_timer.is_stopped():
			wegadoll = group_of_wegas.get_children().pick_random()
			if wegadoll:
				normal_wegadoll_material = wegadoll.wegadoll.material_overlay
				wegadoll.wegadoll.material_overlay = targeted_wegadoll_material
			stay_still_timer.start(stay_still_time)
	
	if Input.is_action_just_pressed("attack"):
		if punchable and piss_off_timer.is_stopped():
			if wegadoll: wegadoll.wegadoll.material_overlay = normal_wegadoll_material
			punchable = false
			sfx.stream = punch_sfx
			sfx.play(0.1)
			hitstop.start()
			Engine.time_scale = 0.0
			death_area.monitoring = false
	
	if !piss_off_timer.is_stopped():
		punchable = false
		rory.show()
		if piss_off_sfx.playing == false: piss_off_sfx.play()
		frame_timer += 1
		if frame_timer == 12:
			randomize()
			frame_timer = 0
			rory.position = Vector2(rng.randf_range(100, 1920), rng.randf_range(50, 1080))
			rory.scale = Vector2(rng.randf_range(6, 10), rng.randf_range(5, 9))
			rory.rotation = randf_range(-360, 360)
	else:
		rory.hide()
		piss_off_sfx.stop()
var frame_timer: int
var rng = RandomNumberGenerator.new()

func _on_hitstop_timeout() -> void:
	Engine.time_scale = 1.0
	pixel_size = 0.05
	death_area.monitoring = true
	Global.points += 400
	Global.style = "+EXPLODED"
	play("explode")
	StyleSFX.play_style_sfx()
	sfx.stream = explosion_sfx
	sfx.play()
	piss_off_timer.stop()
	stay_still_timer.stop()
	stun_timer.start()
	if wegadoll: wegadoll.wegadoll.material_overlay = normal_wegadoll_material
	flash.flash(Color.from_string("ffffffaa", Color.RED), 0.6)
	player.velocity = player.camera.global_basis.z * Vector3(40, 40, 40) + Vector3(0, 3, 0)
	player.boosted.start(0.5)
	player.saveable_fall_leniency_timer.start()
	player.saveable_fall = true
	await animation_looped
	position.y = -100
	hide()
	play("default")
	pixel_size = 0.01

func _on_stay_still_timer_timeout() -> void:
	if wegadoll:
		wegadoll.wegadoll.material_overlay = normal_wegadoll_material
		position = wegadoll.position + Vector3(0, 1.5, 0)
		show()
	else:
		pass

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and animation == "default":
		if kill == true:
			Global.died_to = "rorys"
			get_tree().change_scene_to_file(death_scene)
		elif piss_off == true:
			piss_off_timer.start()
			stay_still_timer.stop()
			punchable = false
			position.y = -100
			Global.health -= damage
			if wegadoll: wegadoll.wegadoll.material_overlay = normal_wegadoll_material
			hide()
			if Global.health <= 0:
				Global.died_to = "rorys"
				get_tree().change_scene_to_file(death_scene)

func _on_fuck_you_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		await get_tree().create_timer(0.5).timeout
		if piss_off_timer.is_stopped() and stun_timer.is_stopped():
			Global.points += 600
			Global.style = "+FUCK YOU RORYS"
			StyleSFX.play_style_sfx()

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true

func _on_punchable_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = true


func _on_punchable_area_3d_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = false

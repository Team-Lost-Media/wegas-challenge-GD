extends Node3D

var punchable: bool = false
var punched: bool = false

@onready var collision: StaticBody3D = $StaticBody3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var sfx: AudioStreamPlayer = $SFX
@onready var punchable_indicator: Sprite3D = $"punchable indicator"
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@export var player: PlayerCharacter
@onready var flash: CanvasLayer = $Flash
@onready var hitstop: Timer = $Hitstop

var explosion_sfx: AudioStream = load("res://assets/SFX/deltarune-explosion.mp3")
var punch_sfx = load("res://assets/SFX/Counter Strike Punch Sound Effect.mp3")

func _on_punchable_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = true


func _on_punchable_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = false
		punched = false

func _process(delta: float) -> void:
	punchable_indicator.visible = punchable and !punched
	if Input.is_action_just_pressed("attack") and punchable and !punched:
		#collision.queue_free()
		#mesh.queue_free()
		#sfx.play()
		punched = true
		sfx.stream = punch_sfx
		sfx.play(0.1)
		Engine.time_scale = 0.0
		hitstop.start()
		#Global.style = "+CRATE"
		#Global.points += 200
		#Global.health += 200/20#handlestylehealthregen
		#StyleSFX.play_style_sfx()



func _on_hitstop_timeout() -> void:
	Engine.time_scale = 1.0
	Global.points += 200
	Global.health += 200/20#handlestylehealthregen
	Global.style = "+EXPLODED"
	animated_sprite_3d.show()
	animated_sprite_3d.play("explode")
	StyleSFX.play_style_sfx()
	sfx.stream = explosion_sfx
	sfx.play()
	flash.flash(Color.from_string("ffffffaa", Color.RED), 0.6)
	player.velocity = player.camera.global_basis.z * Vector3(40, 40, 40) + Vector3(0, 3, 0)
	player.boosted.start(0.5)
	player.saveable_fall_leniency_timer.start()
	player.saveable_fall = true
	player.golden_sigma.modulate = Color("ffffff")
	#Achievements.award("+EXPLODED")
	await animated_sprite_3d.animation_finished
	animated_sprite_3d.hide()

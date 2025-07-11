extends CharacterBody3D

## The node whose position Super John will move towards.
@export var player: Node3D
## The speed at which Super John will move towards the player.
@export var speed: float
## Super John's innacuracy. A value of 0 will result in perfect aim like Wega's, and a value of 1 will result in him basically never hitting you (he will still aim at you, just very badly).
@export_range(0.9, 1.0, 0.001) var inaccuracy: float = 0.0
## The time it takes for Super John to enable.
@export var time_to_enable: float = 3
## If set to [code]true[/code], Super John will not enable automatically. To enable him, another script must change [code]enabled[/code] to [code]true[/code]. True by default.
@export var enable_manually = true
## If set to [code]false[/code], Super John kills the player instead of pushing them. False by default.
@export var kill = false
## The speed Super John must go at to be able to hit the player.
@export var minimum_push_speed: float = 20 
## The damage the player will take from Super John. Only functions if [code]kill[/code] is set to [code]false[/code].
@export var damage: float = 40
## The scene to bring the player to if Super John kills them.
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var ring: Sprite3D = $"Ring Of John"
@onready var start_timer: Timer = $StartTimer
@onready var hitstop_flash: ColorRect = $"HitStop Flash"
@onready var particles: CPUParticles3D = $Particles
@onready var punch_sfx: AudioStreamPlayer = $AudioStreamPlayer

var enabled = false
var punchable = false

func _ready() -> void:
	start_timer.wait_time = time_to_enable
	start_timer.start()
	particles.emitting = false
	ring.hide()
	sprite.play("default")

func _process(delta: float) -> void:
	if enabled:
		#move
		velocity = (global_position.direction_to(player.global_position + Vector3(0, 0.6, 0)) * speed * delta) + (velocity * inaccuracy)
		
		if Input.is_action_just_pressed("attack"):
			if punchable:
				if velocity.length() >= minimum_push_speed:
					punch_sfx.play()
					Engine.time_scale = 0.0
					await get_tree().create_timer(0.1, true, false, true).timeout
					Engine.time_scale = 1.0
					velocity = -velocity
					Global.points += 300
					Global.style = "+DENIED"
					print("DENIED")
					StyleSFX.play_style_sfx()
		
		particles.look_at(player.position)
		particles.rotation.x = 90
		
		if velocity.length() >= minimum_push_speed:
			particles.emitting = true
			ring.show()
			sprite.play("dash")
		else:
			particles.emitting = false
			ring.hide()
			sprite.play("default")
		
		$"debug label".text = str(snappedf(velocity.length(), 0.1))
		
		move_and_slide()

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			Global.died_to = "super john"
			get_tree().change_scene_to_file(death_scene)
		elif velocity.length() >= minimum_push_speed:
			Global.health -= damage
			if Global.health <= 0:
				Global.died_to = "super john"
				get_tree().change_scene_to_file(death_scene)
			body.velocity = velocity + Vector3(0, 30, 0)
			body.boosted.start(0.75)
			velocity = -velocity


func _on_punchable_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = true

func _on_punchable_area_3d_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = false

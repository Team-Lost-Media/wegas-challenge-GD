extends CharacterBody3D

## The node whose position Super John will move towards.
@export var player: Node3D
## The speed at which Super John will move towards the player.
@export var speed: float
## Super John's innacuracy. I have no fucking idea exactly what this does, but it works for what I'm trying to do. Best not to change it.
@export_range(0.9, 1.0, 0.001) var inaccuracy: float = 0.99
## The time it takes for Super John to enable.
@export var time_to_enable: float = 3
## If set to [code]true[/code], Super John will not enable automatically. To enable him, another script must change [code]enabled[/code] to [code]true[/code]. True by default.
@export var enable_manually = true
## If set to [code]false[/code], Super John kills the player instead of pushing them. False by default.
@export var kill = false
## The speed Super John must go at to be able to hit the player.
@export var minimum_push_speed: float = 20 
## The damage the player will take from Super John. Only functions if [code]kill[/code] is set to [code]false[/code].
@export var damage: float = 20
## The scene to bring the player to if Super John kills them.
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
## The Super John Orange Line (tm). Just duplicate the Maltigi Red Line node for this.
@export var line_color: Color

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var ring: Sprite3D = $"Ring Of John"
@onready var start_timer: Timer = $StartTimer
@onready var player_punch_cooldown: Timer = $PlayerPunchCooldown
@onready var just_hit_player: Timer = $"mom i just super john bowling'd all over the place"
@onready var just_got_hit: Timer = $"mom i just got punched"
@onready var hitstop_flash: ColorRect = $"HitStop Flash"
@onready var particles: CPUParticles3D = $Particles
@onready var punch_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var speed_label: Label3D = $"Speed Label"
@onready var punchable_indicator: Sprite3D = $"punchable indicator"

var enabled = false
var punchable = false
var line_frame_timer: int = 0
var debugdraw_config: DebugDraw3DScopeConfig = DebugDraw3D.scoped_config()

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
		
		if Input.is_action_just_pressed("attack") and player_punch_cooldown.is_stopped():
			player_punch_cooldown.start()
			if punchable and just_hit_player.is_stopped():
				if velocity.length() >= minimum_push_speed:
					punch_sfx.play()
					#Engine.time_scale = 0.0
					#await get_tree().create_timer(0.07, true, false, true).timeout
					#Engine.time_scale = 1.0
					just_got_hit.start()
					velocity = -velocity * 1.5
					Global.points += 200
					Global.style = "+DENIED"
					Global.health += 200/20#handlestylehealthregen
					print("DENIED")
					StyleSFX.play_style_sfx()
		
		particles.look_at(player.position)
		particles.rotation.x = 90
		line_frame_timer += 1
		if line_frame_timer == 1:
			line_frame_timer = 0
			DebugDraw3D.draw_line(global_position, global_position + velocity, line_color)
		
		if player.is_on_floor() == true:
			Global.died_to_override = ""
		
		if velocity.length() >= minimum_push_speed:
			particles.emitting = true
			ring.show()
			debugdraw_config.set_thickness(0.1)
			speed_label.offset = Vector2(randf_range(-30, 30), randf_range(-30, 30))
			speed_label.modulate = speed_label.modulate.lerp(Color.RED, clamp(5 * delta, 0.0, 1.0))
			sprite.play("dash")
		else:
			particles.emitting = false
			ring.hide()
			debugdraw_config.set_thickness(0)
			speed_label.offset = Vector2(0, 0)
			speed_label.modulate = speed_label.modulate.lerp(Color.WHITE, clamp(10 * delta, 0.0, 1.0))
			sprite.play("default")
		
		speed_label.text = str(snappedf(velocity.length(), 0.1))
		
		punchable_indicator.visible = punchable and velocity.length() >= minimum_push_speed
		
		move_and_slide()

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and just_got_hit.is_stopped():
		if kill == true:
			Global.died_to = "super john"
			Global.player_died.emit()
			if death_scene != "": get_tree().change_scene_to_file(death_scene)
		elif velocity.length() >= minimum_push_speed:
			Global.health -= damage
			body.health_label.shake_intensity = 5
			if Global.health <= 0:
				Global.died_to = "super john"
				if death_scene != "": get_tree().change_scene_to_file(death_scene)
			body.damage_effects.play_damage_fx("super john")
			punchable = false
			body.velocity = velocity
			body.velocity.y = 25
			body.boosted.start(0.75)
			Global.died_to_override = "super john"
			velocity = -velocity
			
			Achievements.award("super john bowling")


func _on_punchable_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = true

func _on_punchable_area_3d_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = false

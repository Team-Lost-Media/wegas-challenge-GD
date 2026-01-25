extends Sprite3D


@export var player: CharacterBody3D ## The CharacterBody3D node that Maltigi will target.
@export var time_to_enable: float = 3 ## The time it takes for Maltigi to enable automatically.
@export var enable_manually = false ## If set to [code]true[/code], Maltigi will not enable automatically. To enable him, another script must change [code]enabled[/code] to [code]true[/code]. False by default.
@export var dash_cooldown: float = 3 ## The time it takes for Maltigi to dash again.
@export var dash_delay: float = 0.5 ## The time between Maltigi choosing a target position, and dashing towards it.
@export var dash_speed: float = 125 ## How quickly Maltigi will dash. Keep in mind this will be "multiplied" by delta.
@export var kill = true ## If set to [code]false[/code], Maltigi cannot kill the player.
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var died_to: String = "maltigi" ## A special identifier used to set the tips in the THE IDOL game over screen. Best not to change this, unless its for Glitchigi.
@export var smart = false ## If set to [code]true[/code], Maltigi will predict the targets's movement (using their velocity) and dash where they're going. Otherwise, he will just dash at their position.
@export var smart_multiplier: float = 1.2 ## Only functions if [code]smart[/code] is set to [code]true[/code]. Maltigi will multiply the target's velocity by this number in the movement prediction calculation.
@export var enable_overshoot: bool = true ## If set to [code]true[/code], Maltigi will overshoot the target.
@export var overshoot_distance: float = 10 ## Only functions if [code]enable_overshoot[/code] is set to [code]true[/code]. Maltigi will overshoot the player by this distance. This is added onto the final target and is NOT a multiplier.
@export var line_color: Color
@export_group("Malt Rush")
@export var malt_rush_enabled: bool = false ## The Malt Rush makes Maltigi quickly dash for a brief period.
@export var malt_rush_multiplier: float = 2 ## How much faster Maltigi's dashes will be during a Malt Rush.
@export var malt_rush_duration: float = 5.0 ## How long the Malt Rush lasts.
@export var malt_rush_cooldown: float = 5.0 ## The time between Malt Rushes.

@onready var start_timer: Timer = $StartTimer
@onready var dash_cooldown_timer: Timer = $StartTimer
@onready var dash_delay_timer: Timer = $DashDelay
@onready var malt_rush_active_timer: Timer = $MaltRushActiveTimer
@onready var malt_rush_cooldown_timer: Timer = $MaltRushCooldownTimer

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


var enabled = false
var moving = false
var malt_rushing = false
var target_position: Vector3
var delta_but_the_one_i_used_in_the_dash_function: float

func _ready() -> void:
	DebugDraw3D.new_scoped_config().set_thickness(0.2)
	if enable_manually == false:
		start_timer.start(time_to_enable)

func _process(delta: float) -> void:
	delta_but_the_one_i_used_in_the_dash_function = delta
	
	if enabled == true:
		
		
		if dash_cooldown_timer.is_stopped():
			moving = false
			if smart:
				target_position = player.position + ((position.direction_to(player.position) * overshoot_distance) * float(enable_overshoot)) + (Vector3(player.velocity.x, player.velocity.y * float(player.just_jumped.is_stopped()), player.velocity.z) * Vector3(smart_multiplier, smart_multiplier, smart_multiplier))
			else:
				target_position = player.position + ((position.direction_to(player.position) * overshoot_distance) * float(enable_overshoot))
			dash_delay_timer.start(dash_delay)
			#line.draw(position, target_position)
			DebugDraw3D.draw_line(position, target_position, line_color, dash_delay)
			#draw the line
			if malt_rushing:
				dash_cooldown_timer.start(dash_cooldown / malt_rush_multiplier)
			else:
				dash_cooldown_timer.start(dash_cooldown)
		
		if moving == true:
			position = position.move_toward(target_position, dash_speed * delta_but_the_one_i_used_in_the_dash_function)
		
	if malt_rushing:
		modulate = Color.RED
	else:
		modulate = Color.WHITE

func _on_start_timer_timeout() -> void:
	enabled = true

func _on_dash_delay_timeout() -> void:
	moving = true
	#line.mesh.clear_surfaces()
	#EEEEEAIAIAIARARRHGHGHHARARA
	audio.play()
	print("player: ", player.position, "	target: ", target_position)

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			Global.died_to = died_to
			Global.player_died.emit()
			get_tree().change_scene_to_file(death_scene)

func start(timer = false) -> void:
	kill = true
	show()
	if timer == false:
		enabled = true
	else:
		start_timer.start(time_to_enable)
	if malt_rush_enabled:
		malt_rush_cooldown_timer.start(malt_rush_cooldown)

func stop() -> void:
	kill = false
	enabled = false
	hide()

func _on_malt_rush_cooldown_timer_timeout() -> void:
	malt_rush_active_timer.start(malt_rush_duration)
	malt_rushing = true

func _on_malt_rush_active_timer_timeout() -> void:
	malt_rush_cooldown_timer.start(malt_rush_cooldown)
	malt_rushing = false

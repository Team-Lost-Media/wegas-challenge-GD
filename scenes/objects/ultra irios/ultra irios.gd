extends Sprite3D

## The CharacterBody3D node whose position Ultra Irios will move towards and shoot at.
@export var playerpos: CharacterBody3D
## The speed at which Ultra Irios will move towards the player.
@export var speed: float = 7
## The time it takes for Ultra Irios to enable.
@export var time_to_enable: float = 3
## If set to [code]true[/code], Ultra Irios will not enable automatically. To enable him, another script must change [code]enabled[/code] to [code]true[/code]. False by default. For Ultra Irios only, you must also run the method start() on the cooldown_timer.
@export var enable_manually = false
## If set to [code]false[/code], Ultra Irios cannot kill the player by colliding with them. True by default.
@export var kill = true
## The scene to bring the player to if Ultra Irios kills them by colliding with them.
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
## If set to [code]true[/code], you can use [code]ercentage_wegadolls_left_to_speed_curve[/code] (which is below) to change how Ultra Irios speeds up or slows down with varying Wegadoll percentages.
@export var speed_up_with_wegadolls = false
## Only functions if [code]speed_up_with_wegadolls[/code] is set to [code]true[/code]. [br]Adds a multiplier to Ultra Irios's speed based on the Y value of the curve at X. The X value is the percentage of Wegadolls remaining.
@export var percentage_wegadolls_left_to_speed_curve: Curve
## The projectile Ultra Irios will shoot. Must have a [code]speed[/code] value.
@export var fireball: PackedScene
@export var fireball_death_scene = "res://scenes/menus/gameover/gameover.tscn"
## The time in seconds Ultra Irios will take to fire.
@export var cooldown: float = 1.0
@export var fireball_speed: float = 17.5
@export var fireball_damage: float = 40

@onready var start_timer: Timer = $StartTimer
@onready var juke_timer: Timer = $JukeTimer
@onready var enrage_color_timer: Timer = $EnrageColorTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var enabled = false #if false, ultra irios doesnt move and cant be styled on
var juke_speed_multiplier: float = 1.0 #handles slowdown when juked
var wegadoll_speed_multiplier: float = 1.0 #handles speedup with more wegadolls collected
var wegadoll_speed_multiplier_minimum: float = 0.0 #max(speed_multiplier, this_var)
var max_wegadolls: int #the amount of wegadolls in the scene when _ready() happens
var wegadoll_percentage: float = 1.0 #pretty self explanatory
var status: String = "" #multi-use status for stuff like debuffs
var rage: int #rage number. it goes up with style bonuses and if it goes above 1000 wegadoll_speed_multiplier_minimum = 1

var this_vector_is_a_rotation_pointed_at_the_player_wow: Vector3

func _ready() -> void:
	start_timer.wait_time = time_to_enable
	start_timer.start()
	if enable_manually == true:
		pass

func _process(delta: float) -> void:
	if enabled:
		#move
		global_position = global_position.move_toward(playerpos.global_position + Vector3(0, 0.6, 0), delta * speed * juke_speed_multiplier * max(wegadoll_speed_multiplier, wegadoll_speed_multiplier_minimum))
		
		#update this_vector_is_a_rotation_pointed_at_the_player_wow
		var fuck = rotation
		look_at(playerpos.position)
		this_vector_is_a_rotation_pointed_at_the_player_wow = rotation
		rotation = fuck
		
		#handle speedup with less wegadolls
		if speed_up_with_wegadolls:
			if Global.max_wegadolls != 0:
				wegadoll_percentage =  float(Global.wegadolls_left) / float(Global.max_wegadolls)
			wegadoll_speed_multiplier = percentage_wegadolls_left_to_speed_curve.sample(wegadoll_percentage)
			
			#print("wegadolls_left = ", Global.wegadolls_left)
			#print("max_wegadolls = ", Global.max_wegadolls)
			#print("wegadoll_percentage = ", wegadoll_percentage)
			#print("wegadoll_speed_multiplier = ", wegadoll_speed_multiplier)
		
		#handle slowdown when juked
		if status == "JUKED":
			if juke_speed_multiplier < 0.8:
				juke_speed_multiplier = lerp(juke_speed_multiplier, 1.0, 0.8 * delta)
				#print("juke speed multiplier = ", juke_speed_multiplier)
			else:
				juke_speed_multiplier = 1
				status = ""
		
		if modulate != Color.WHITE and enrage_color_timer.is_stopped():
			modulate = modulate.lerp(Color.WHITE, 0.66 * delta)
		
		if Global.x_seconds_passed(delta, 0.01) == true and rage < 1000:
			rage -= 1
		if rage > 1000 and rage < 999999:
			#enrage
			Global.style = "+ENRAGED"
			StyleSFX.play_style_sfx(6)
			Global.points += 400
			modulate = Color.RED
			enrage_color_timer.start()
			rage = 99999999
			wegadoll_speed_multiplier_minimum = 1

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true
		cooldown_timer.start(cooldown)

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			Global.died_to = "ultra irios"
			Global.player_died.emit()
			get_tree().change_scene_to_file(death_scene)


func _on_above_wega_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled:
			rage += 200
			Global.points += 200
			Global.style = "+ABOVE"
			print("ABOVE")
			StyleSFX.play_style_sfx()

func _on_juke_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if enabled and !body.just_dashed.is_stopped() and juke_timer.is_stopped():
			juke_timer.start()
			juke_speed_multiplier = 0.5
			status = "JUKED"
			rage += 500
			Global.points += 500
			Global.style = "+JUKED"
			print("JUKED")
			StyleSFX.play_style_sfx()

var fireball_number: int
func _on_cooldown_timer_timeout() -> void:
	fireball_number += 1
	#shoot fireball
	var shot = fireball.instantiate()
	add_sibling(shot)
	shot.transform = global_transform
	shot.linear_velocity = (playerpos.position + Vector3(0, 0.5, 0)- global_position).normalized() * fireball_speed
	print(shot.linear_velocity)
	print(shot.rotation_degrees)
	shot.death_scene = fireball_death_scene
	shot.damage = fireball_damage
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	cooldown_timer.start(cooldown)

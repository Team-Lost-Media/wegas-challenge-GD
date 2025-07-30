extends Sprite3D

## The node whose position Wega will move towards.
@export var playerpos: Node3D
## The speed at which Wega will move towards the player. Usually higher than the player's default speed.
@export var speed: float
## The time it takes for Wega to enable.
@export var time_to_enable: float = 3
## If set to [code]true[/code], Wega will not enable automatically. To enable him, another script must change [code]enabled[/code] to [code]true[/code]. False by default.
@export var enable_manually = false
## If set to [code]false[/code], Wega cannot kill the player. True by default.
@export var kill = true
## The scene to bring the player to if Wega kills them.
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
## If set to [code]true[/code], you can use [code]ercentage_wegadolls_left_to_speed_curve[/code] (which is below) to change how Wega speeds up or slows down with varying Wegadoll percentages.
@export var speed_up_with_wegadolls = false
## Only functions if [code]speed_up_with_wegadolls[/code] is set to [code]true[/code]. [br]Adds a multiplier to Wega's speed based on the Y value of the curve at X. The X value is the percentage of Wegadolls remaining. Typically, Wega starts off slower than normal at high percentages and gets faster at slower percentages.
@export var percentage_wegadolls_left_to_speed_curve: Curve
@export_group("WCTI Enrage")
## If set to [code]true[/code], Wega cannot enrage normally (by being styled on fast enough), but will only enrage when [code]enrage_when_x_left[/code] Wegadolls remain to be collected. Enraging will also make him go faster. This stacks with [code]percentage_wegadolls_left_to_speed_curve[/code].
@export var wcti_enrage = false
## Only functions if [code]wcti_enrage[/code] is set to [code]true[/code]. [br]Wega will enrage when X Wegadolls remain. In WC:TI, it's 50.
@export var enrage_when_x_left: int
## Only functions if [code]wcti_enrage[/code] is set to [code]true[/code]. The speed at which Wega will move when enraged.
@export var wcti_enraged_speed: float
## Only functions if [code]wcti_enrage[/code] is set to [code]true[/code]. Wega's new texture when enraged.
@export var wcti_enraged_texture: Texture2D
## Only functions if [code]wcti_enrage[/code] is set to [code]true[/code]. If the old and new textures have different resolutions, you must change this value to keep Wega the same size.
@export var new_texture_pixel_size: float

@onready var start_timer: Timer = $StartTimer
@onready var juke_timer: Timer = $JukeTimer
@onready var enrage_color_timer: Timer = $EnrageColorTimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var enabled = false #if false, wega doesnt move and cant be styled on
var juke_speed_multiplier: float = 1.0 #handles slowdown when juked
var wegadoll_speed_multiplier: float = 1.0 #handles speedup with more wegadolls collected
var wegadoll_speed_multiplier_minimum: float = 0.0 #max(speed_multiplier, this_var)
var max_wegadolls: int #the amount of wegadolls in the scene when _ready() happens
var wegadoll_percentage: float = 1.0 #pretty self explanatory
var status: String = "" #multi-use status for stuff like debuffs
var rage: int #rage number. it goes up with style bonuses and if it goes above 1000 wegadoll_speed_multiplier_minimum = 1

func _ready() -> void:
	start_timer.wait_time = time_to_enable
	start_timer.start()

func _process(delta: float) -> void:
	if enabled:
		#move
		global_position = global_position.move_toward(playerpos.global_position + Vector3(0, 0.6, 0), delta * speed * juke_speed_multiplier * max(wegadoll_speed_multiplier, wegadoll_speed_multiplier_minimum))
		
		#BWAAAAUGH
		if not audio.playing:
			audio.play()
		
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
		if rage > 1000 and rage < 999999 and wcti_enrage == false:
			#enrage
			Global.style = "+ENRAGED"
			StyleSFX.play_style_sfx(6)
			Global.points += 400
			modulate = Color.RED
			enrage_color_timer.start()
			rage = 99999999
			wegadoll_speed_multiplier_minimum = 1
		
		if wcti_enrage == true:
			if Global.wegadolls_left <= enrage_when_x_left and texture != wcti_enraged_texture:
				texture = wcti_enraged_texture
				pixel_size = new_texture_pixel_size
				speed = wcti_enraged_speed

func _on_start_timer_timeout() -> void:
	if enable_manually == false:
		enabled = true


func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			Global.died_to = "wega"
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
		if enabled and !body.boosted.is_stopped():
			status = "JUKED"
			rage += 1000
			Global.points += 1000
			Global.style = "+EXPLOSION JUKE"
			print("EXPLOSION JUKE")
			StyleSFX.play_style_sfx()
			return
		if enabled and !body.just_dashed.is_stopped() and juke_timer.is_stopped():
			juke_timer.start()
			juke_speed_multiplier = 0.5
			status = "JUKED"
			rage += 400
			Global.points += 400
			Global.style = "+JUKED"
			print("JUKED")
			StyleSFX.play_style_sfx()

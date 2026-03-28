extends Control

@onready var you_died_to: Label = $"you died to"
@onready var tips: Label = $"tips"
@onready var insta_exit_prevention: Timer = $insta_exit_prevention
@onready var results: Control = $results
@onready var stats: Label = $results/stats
@onready var death_fx: Control = $DeathFX

func _ready() -> void:
	results.modulate.a = 0
	stats.text = "died at lap " + str(Global.lap) + " with " + str(Global.wegadolls_left) + " wegadolls left\n" + "
	time: " + Global.time_as_string + "
	style: " + str(Global.points)
	
	
	
	Engine.time_scale = 1.0
	StyleSFX.stop()
	if Global.died_to_override != "":
		Global.died_to = Global.died_to_override
	do_the_fx()
	#region old stuff
	if Global.died_to == "fall":
		you_died_to.text = "you FELL"
	elif Global.died_to == "ultra irios fireball":
		you_died_to.text = "you died to a FIREBALL"
	else:
		you_died_to.text = str("you died to ", str(Global.died_to).to_upper())
	match Global.died_to:
		"fall":
			tips.text = '''Golden Sigma will only save you once from falling!
(The only exceptions are explosions, such as the Rorys Explosion)

Don't underestimate how easy it is to die to falling!'''
		"wega":
			tips.text = '''Don't let the other enemies (especially Rorys) distract you!
Wega is still the most dangerous threat
out of all of the lap 1 enemies.
Never underestimate him when he's enraged!'''
		"maltigi":
			tips.text = '''Always keep the Maltigi Red Line in mind!
Maltigi will always telegraph his trajectory with the Maltigi Red Line.
If you're about to go through it, either take a different path or jump over it.'''
		"rorys":
			tips.text = '''Remember to punch Rorys with ATTACK (Left Click)!
It gives you an extremely helpful movement boost.
Also, Golden Sigma is guaranteed to save you if you fall right after punching Rorys.
Rorys can only spawn on Wegadolls: the Wegadoll he will spawn on will be marked blue.'''
		"ultra irios":
			tips.text = '''Never underestimate Ultra Irios!
Even if he is slower than Wega, he will still instakill you if you touch him!'''
		"ultra irios fireball":
			tips.text = '''Keep your distance from Ultra Irios!
If you hear him shooting, get away as fast as possible.
The fireballs, while faster than you, are extremely easy to dodge if you keep your distance: the only time they're truly dangerous is when you're close to Ultra Irios. '''
		"super john":
			tips.text = '''Super John can only hit you when he's at 20 speed or higher! When he can hit you, he will play a unique animation and will also have extra particles!
Keeping track of where Super John is is much easier if you pay attention to the line sticking out of him, as it keeps track of his velocity!
Super John, like Rorys, can be punched with ATTACK (Left Click)! Doing so will reverse his velocity.'''
		"glitchigi":
			tips.text = '''Glitchigi behaves the same as Maltigi, except he occasionally rushes at you a LOT faster than he usually does!
Despite this, however, hes still just a faster Maltigi.
The same tips against Maltigi will function just as well against Glitchigi!'''
		"shoe bench":
			tips.text = "idk lmao just go fast"
		
			
		_:
			tips.text = "if youre seeing this then you died to something \n that i didnt give a built-in tip yet \n \n please report this"
			#endregion
	await get_tree().create_timer(1.5).timeout
	var tween = create_tween()
	tween.tween_property(results, "modulate:a", 0.9, 1)
	var tween2 = create_tween()
	tween2.tween_property(death_fx, "modulate:v", 0.3, 1)

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if insta_exit_prevention.is_stopped():
		if Input.is_action_just_pressed("jump"):
			get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")
			Global.reset()
		if Input.is_action_just_pressed("escape"):
			get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func do_the_fx() -> void:
	match Global.died_to:
		"wega":
			death_fx.wega.show()
			death_fx.wega.anim()
		"maltigi":
			if randi_range(1, 2) == 1:
				death_fx.malt1.show()
				death_fx.malt1.anim()
			else:
				death_fx.malt2.show()
				death_fx.malt2.anim()
		"fall":
			match randi_range(1, 1):
				1:
					death_fx.fall1.show()
					death_fx.fall1.anim()
				2:
					pass
				3:
					pass
		"rorys":
			death_fx.rorys.show()
			death_fx.rorys.anim()

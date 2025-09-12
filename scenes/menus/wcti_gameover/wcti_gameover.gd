extends Control

@onready var you_died_to: Label = $"you died to"
@onready var tips: Label = $"tips"

func _ready() -> void:
	Engine.time_scale = 1.0
	StyleSFX.stop()
	if Global.died_to_override != "":
		Global.died_to = Global.died_to_override
	
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

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")
		Global.reset()

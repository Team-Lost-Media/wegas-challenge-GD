extends Node2D

@onready var you_died_to: Label = $"Label/you died to"
@onready var tips: Label = $Label/tips

func _ready() -> void:
	Engine.time_scale = 1.0
	you_died_to.text = str("you died to ", str(Global.died_to).to_upper())
	match Global.died_to:
		"fall":
			tips.text = '''Golden Sigma will only save you once from falling!
(The only exception is the Rorys Explosion)

Don't underestimate how easy it is to die to falling!'''
		"wega":
			tips.text = '''Don't let the other enemies (especially Rorys) distract you!
Wega is still the most dangerous threat
out of all of the lap 1 enemies.'''
		"maltigi":
			tips.text = '''Always stay on the move!
Maltigi might be very fast, but he's also very stupid.
He will not predict your movement whatsoever:
just by walking, you are dodging Maltigi.'''
		"shoe bench":
			tips.text = "idk lmao just go fast"
		_:
			tips.text = "if youre seeing this then you died to something \n that i didnt give a built-in tip yet \n \n please report this"

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")
		Global.reset()

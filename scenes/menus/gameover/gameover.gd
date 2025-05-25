extends Node2D

@export var points_and_time_curve: Curve
@onready var final_score: Label = $Label/Label3
@onready var explanation: Label = $Label/Label4/Label5
@onready var button_but_not_really_a_button_i_just_use_this_to_check_if_youre_hovering_over_label4: Button = $Label/Label4/Button

func _ready() -> void:
	#calculate final_score
	var score
	var score_multiplier
	score_multiplier = points_and_time_curve.sample(Global.time_in_seconds)
	score = Global.points * score_multiplier
	print("score multiplier = ", score_multiplier)
	#actually display it
	final_score.text = str(snapped(score, 1), ")")

func _process(delta: float) -> void:
	
	#display the explanation if youre hovering over "sort of"
	if button_but_not_really_a_button_i_just_use_this_to_check_if_youre_hovering_over_label4.is_hovered() == true:
		explanation.show()
		#note: this only works if the button is visible for some reason?
	else:
		explanation.hide()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		if Global.tutorial == true:
			get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
			Global.reset()
		else:
			get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")
			Global.reset()

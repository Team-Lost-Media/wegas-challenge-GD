extends Node2D

## literally just copied from gameover.gd smh
##haha not anymore xeth

@onready var timer: Timer = $Timer
@onready var time: Label = $VBoxContainer/time
@onready var points: Label = $VBoxContainer/points
@onready var final_score: Label = $"VBoxContainer/final score number"
@onready var high_score_label: Label = $"VBoxContainer/new high score"
@export var points_and_time_curve: Curve
@export var tutorial = false

var high_score: bool

func _ready() -> void:
	if tutorial == false:
		timer.start()
		
		time.text = str("time: ", Global.time_as_string)
		points.text = str("points: ", str(Global.points))
		#calculate final_score
		var score
		var score_multiplier
		score_multiplier = points_and_time_curve.sample(Global.time_in_seconds)
		score = Global.points * score_multiplier
		print("score multiplier = ", score_multiplier)
		#actually display it
		final_score.text = str(snapped(score, 1))
		#save it and show off if it's a high score
		if Save.load_score() < snapped(score, 1):
			Save.save_score(snapped(score, 1))
			high_score_label.label_settings.font_color = Color(1, 0, 0)
			high_score = true

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if high_score == true:
		high_score_label.label_settings.font_color.h += 0.2 * delta
		high_score_label.text = "NEW HIGH SCORE!"
	else:
		high_score_label.text = str("previous high score: ", Save.load_score())
	
	if tutorial == false:
		if Input.is_action_just_pressed("jump") and timer.is_stopped():
			get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
			Global.reset()
	else:
		if Input.is_action_just_pressed("jump"):
			get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
			Global.reset()

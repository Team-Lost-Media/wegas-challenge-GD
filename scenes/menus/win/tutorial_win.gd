extends Control

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
	Save.progress_dict.set("beat classic tutorial", true)
	Save.save_progress()

func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Global.reset()

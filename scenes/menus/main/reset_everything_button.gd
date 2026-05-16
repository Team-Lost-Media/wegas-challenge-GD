extends Button

var times_pressed: int

func _ready() -> void:
	text = "Reset ALL SAVE DATA"
	times_pressed = 0

func _pressed() -> void:
	times_pressed += 1
	
	match times_pressed:
		1:
			text = "Are you sure?"
		2:
			text = "Are you SURE?"
		3:
			get_tree().change_scene_to_file("res://scenes/menus/main/delete everything/delete everything.tscn")

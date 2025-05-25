extends Button

var times_pressed: int

func _ready() -> void:
	text = "Reset High Score"
	times_pressed = 0

func _on_pressed() -> void:
	times_pressed += 1
	
	match times_pressed:
		1:
			text = "Are you sure?"
		2:
			text = "This resets your high score."
		3:
			text = "Last warning."
		4:
			text = "High score reset!"
			Save.reset_score()

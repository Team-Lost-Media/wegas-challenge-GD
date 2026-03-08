extends Label

func _ready() -> void:
	var score: int
	score = Save.load_score()
	text = "HIGH SCORE: " + str(score)

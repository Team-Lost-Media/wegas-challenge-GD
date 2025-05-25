extends Node

const SAVE_SCORE_FILE_PATH = "res://high_score.wegakill"

func save_score(score):
	var file = FileAccess.open(SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(score))

func load_score():
	var file = FileAccess.open(SAVE_SCORE_FILE_PATH, FileAccess.READ)
	var score = int(file.get_as_text())
	return score

func reset_score():
	var file = FileAccess.open(SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(0))

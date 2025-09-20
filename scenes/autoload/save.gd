extends Node

const CLASSIC_SAVE_SCORE_FILE_PATH = "user://wegakill - classic highscore.sav"
const WCTI_SAVE_SCORE_FILE_PATH = "user://wegakill - the idol highscore.sav"
const SAVE_ACHIEVEMENTS_FILE_PATH = "user://wegakill - achievements.sav"

func save_score(score):
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(score))

func load_score():
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.READ)
	var score: int
	if file != null:
		score = int(file.get_as_text())
	return score

func reset_score():
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(0))

func save_wcti_score(score):
	var file = FileAccess.open(WCTI_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(score))

func load_wcti_score():
	var file = FileAccess.open(WCTI_SAVE_SCORE_FILE_PATH, FileAccess.READ)
	var score: int
	if file != null:
		score = int(file.get_as_text())
	return score

func reset_wcti_score():
	var file = FileAccess.open(WCTI_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(0))

var achievements_dict: Dictionary = {
	"winga": false, #beat classic mode
	"wexecution": false, #beat lap 1
	"wegafadence": false, #beat lap 2
	"so close, yet so far": false, #fail to collect the idol
	"idiot": false, #die in the pause before transition to lap 2
	"task failed succesfully": false, #die
	"haha": false, #die with 1 wegadoll left
	"super john bowling": false, #super john bowling
	"thnak you.": false, #get saved by golden sigma
	"+exploded": false, #punch rorys
	"recolorpedia time": 0.0, #time spent in the recolorpedia
	"certified wega expert": false, #spend 30 minutes in the recolorpedia
	"speedrunner": false, #beat classic mode in less than 35 seconds
	"wegakill": false, #reach wegakill rank
	"shoe bench": false, #get +SHOE BENCH
	"ultrawegacombo": false, #get +ULTRAWEGACOMBO
	"ultra winga": false, #beat classic mode with >10000 score
}

func save_achievements():
	var file = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(achievements_dict)

func load_achievements():
	var file = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.READ)
	var contents = file.get_as_text()
	print(JSON.parse_string(contents))
	return JSON.parse_string(contents)


'''
var data_to_send = ["a", "b", "c"]
var json_string = JSON.stringify(data_to_send)
# Save data
# ...
# Retrieve data
var json = JSON.new()
var error = json.parse(json_string)
if error == OK:
	var data_received = json.data
	if typeof(data_received) == TYPE_ARRAY:
		print(data_received) # Prints the array.
	else:
		print("Unexpected data")
else:
	print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
'''

extends Node

const CLASSIC_SAVE_SCORE_FILE_PATH = "user://wegakill - classic highscore.sav"
const WCTI_SAVE_SCORE_FILE_PATH = "user://wegakill - the idol highscore.sav"
const SAVE_ACHIEVEMENTS_FILE_PATH = "user://wegakill - achievements.sav"
const SAVEFILE_VERSION_FILE_PATH = "user://wegakill - savefile version.sav"

var savefile_version = 2

var load_saves = true

func save_score(score):
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(score))

func load_score():
	if load_saves:
		var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.READ)
		var score: int = 0
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
	if load_saves:
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
	"WEXECUTION": false, #beat lap 1
	"WEGAFADENCE": false, #beat lap 2
	"so close, yet so far": false, #fail to collect the idol
	"idiot": false, #die in the pause before transition to lap 2
	"Task Failed Succesfully!": false, #die to every enemy
	"haha": false, #die with 1 wegadoll left
	"super john bowling": false, #super john bowling
	"thnak you.": false, #get saved by golden sigma
	"+EXPLODED": false, #punch rorys
	"certified wega expert": false, #open the recolorpedia
	"Speedrunner": false, #beat classic mode in less than 35 seconds
	"WEGAKILL": false, #reach wegakill rank
	"shoe bench": false, #get +SHOE BENCH
	"ULTRAWEGACOMBO": false, #get +ULTRAWEGACOMBO
	"ultra winga": false, #beat classic mode with >10000 score
}

func save_achievements():
	var file = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(achievements_dict)
	file.store_string(json_string)

func load_achievements():
	if load_saves:
		var file = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.READ)
		var contents = file.get_as_text()
		print(contents)
		#print(JSON.parse_string(contents))
		#return JSON.parse_string(contents)
		var json = JSON.new()
		var error = json.parse(contents)
		if error == OK:
			var data_received = json.data
			achievements_dict = data_received

func reset_everything():
	print("LOST MEDIA!")
	var wctihighscore = FileAccess.open(WCTI_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	wctihighscore.store_string(str(0))
	
	var classichighscore = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	classichighscore.store_string(str(0))
	
	var achievements = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.WRITE)
	var achievements_json_string = JSON.stringify(achievements_dict)
	achievements.store_string(achievements_json_string)
	
	var savefileversion = FileAccess.open(SAVEFILE_VERSION_FILE_PATH, FileAccess.WRITE_READ)
	savefileversion.store_string(str(savefile_version))

func _ready() -> void:
	var file = FileAccess.open(SAVEFILE_VERSION_FILE_PATH, FileAccess.READ)
	if file == null:
		reset_everything()
		return
		
	var saved_savefile_version = int(file.get_as_text())
	if saved_savefile_version != savefile_version:
		load_saves = false
		get_tree().change_scene_to_file("res://scenes/menus/save error/save error menu.tscn")

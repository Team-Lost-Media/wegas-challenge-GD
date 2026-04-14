extends Node

const CLASSIC_SAVE_SCORE_FILE_PATH = "user://wegakill - classic highscore.sav"
const PROGRESS_SAVE_FILE_PATH = "user://wegakill - game progress.sav"
const SAVE_ACHIEVEMENTS_FILE_PATH = "user://wegakill - achievements.sav"
const SAVEFILE_VERSION_FILE_PATH = "user://wegakill - savefile version.sav"

var savefile_version = 7

var load_saves = true

#region score
func save_score(score):
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(score))

func load_score() -> int:
	if load_saves:
		var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.READ)
		var score: int = 0
		if file != null:
			score = int(file.get_as_text())
		if score != null:
			return score
		else: return 0
	return 0

func reset_score():
	var file = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	file.store_string(str(0))
#endregion
#region achievements
var achievements_dict: Dictionary[String, bool] = {
	"winga": false, #beat classic mode "you winga!"
	"WEXECUTION": false, #beat lap 1 "i cant believe green lawson got wexecuted :pensive:"
	"WEGAFADENCE": false, #beat lap 2 "Don't get caught."
	"so close, yet so far": false, #fail to collect the idol "one must imagine me happy because im not"
	"idiot": false, #die in the pause before transition to lap 2 "guy stupid"
	#"Task Failed Succesfully!": false, #die to every enemy "insert fanfare here"
	"haha": false, #die with 1 wegadoll left "point and laugh"
	"super john bowling": false, #super john bowling "super john bowling"
	"thnak you.": false, #get saved by golden sigma "your wcleom."
	"+EXPLODED": false, #punch rorys "fuck you rorys"
	"certified wega expert": false, #open the recolorpedia "pdhd in media"
	"Speedrunner": false, #beat classic mode in less than 40 seconds "you really are a speedy runner"
	"WEGAKILL": false, #reach wegakill rank "oh my god itsl ike the game wegas and the meme lodia"
	"shoe bench": false, #get +SHOE BENCH "shoe bench"
	"ULTRAWEGACOMBO": false, #get +ULTRAWEGACOMBO "that's too many combo. you shouldnt have posted about so many combo"
	"ultra winga": false, #beat classic mode with >10000 score "you winga! but with STYLE"
	#"ouroboros": false, #do 100 runs "this really was our oboros"
	"embrace the malt": false, #run into maltigi while he's not moving
	"thanks for playing!": false, #beat the credits roll "orange line? the fuck is that supposed to mean?"
}

func save_achievements():
	var file = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(achievements_dict.values())
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
			var data_received: Array = json.data
			var i: int = 0
			for element in achievements_dict:
				achievements_dict.set(element, data_received[i])
				i += 1
#endregion
#region progress
var progress_dict: Dictionary = {
	"beat classic tutorial": false,
	"beat classic": false,
	"beat wcti tutorial": false,
	"beat wcti": false,
	"beat wcti orange line": false
}

func save_progress():
	var file = FileAccess.open(PROGRESS_SAVE_FILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(progress_dict.values())
	file.store_string(json_string)

func load_progress():
	if load_saves:
		var file = FileAccess.open(PROGRESS_SAVE_FILE_PATH, FileAccess.READ)
		var contents = file.get_as_text()
		print(contents)
		#print(JSON.parse_string(contents))
		#return JSON.parse_string(contents)
		var json = JSON.new()
		var error = json.parse(contents)
		if error == OK:
			var data_received: Array = json.data
			var i: int = 0
			for element in progress_dict:
				progress_dict.set(element, data_received[i])
				i += 1
#endregion

func reset_everything():
	print("LOST MEDIA!")
	
	var classichighscore = FileAccess.open(CLASSIC_SAVE_SCORE_FILE_PATH, FileAccess.WRITE)
	classichighscore.store_string(str(0))
	
	var achievements = FileAccess.open(SAVE_ACHIEVEMENTS_FILE_PATH, FileAccess.WRITE)
	var achievements_json_string = JSON.stringify(achievements_dict.values())
	achievements.store_string(achievements_json_string)
	
	var progress = FileAccess.open(PROGRESS_SAVE_FILE_PATH, FileAccess.WRITE)
	var progress_json_string = JSON.stringify(progress_dict.values()))
	progress.store_string(progress_json_string)
	
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
	
	load_achievements()
	load_progress()

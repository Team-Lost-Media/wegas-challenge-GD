extends Control

@onready var achievement_name: RichTextLabel = $TextureRect/name
@onready var achievement_name2: RichTextLabel = $TextureRect2/name
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $TextureRect2/AnimationPlayer
@onready var achievement_icon: TextureRect = $"TextureRect/achievement icon"
@onready var achievement_icon2: TextureRect = $"TextureRect2/achievement icon 2"

var achievement_to_icon_dict: Dictionary = {
	"winga": "res://assets/textures/achievements/winga.png", #beat classic mode "you winga!"
	"WEXECUTION": "res://assets/textures/achievements/wexecution.png", #beat lap 1 "i cant believe green lawson got wexecuted :pensive:"
	"WEGAFADENCE": "res://assets/textures/achievements/wegafadence.png", #beat lap 2 "this really was our wegafadence"
	"so close, yet so far": "res://assets/textures/achievements/so close yet so far.png", #fail to collect the idol "you're almost there! keep trying!"
	"idiot": "res://assets/textures/achievements/idiot.png", #die in the pause before transition to lap 2 "guy stupid"
	"Task Failed Succesfully!": "res://assets/textures/achievements/task failed succesfully.png", #die to every enemy "insert fanfare here"
	"haha": "res://assets/textures/achievements/haha.png", #die with 1 wegadoll left "point and laugh"
	"super john bowling": "res://assets/textures/achievements/super john bowling.png", #super john bowling "super john bowling"
	"thnak you.": "res://assets/textures/achievements/thnak you.png", #get saved by golden sigma "your wcleom."
	"+EXPLODED": "res://assets/textures/achievements/exploded.png", #punch rorys "fuck you rorys"
	"certified wega expert": "res://assets/textures/achievements/certified wega expert.png", #open the recolorpedia "pdhd in media"
	"Speedrunner": "res://assets/textures/achievements/speedrunner.png", #beat classic mode in less than 40 seconds "you really are a speedy runner"
	"WEGAKILL": "res://assets/textures/achievements/wegakill.png", #reach wegakill rank "oh my god itsl ike the game wegas and the meme lodia"
	"shoe bench": "res://assets/textures/achievements/shoe bench.png", #get +SHOE BENCH "shoe bench"
	"ULTRAWEGACOMBO": "res://assets/textures/achievements/ultrawegacombo.png", #get +ULTRAWEGACOMBO "that's too many combo. you shouldnt have posted about so many combo"
	"ultra winga": "res://assets/textures/achievements/ultra winga.png", #beat classic mode with >10000 score "you winga! but with STYLE"
	"ouroboros": "res://assets/textures/achievements/ouroboros.png", #do 100 runs "this really was our oboros"
	"embrace the malt": "", #run into maltigi while he's not dashing
	"thanks for playing!": "res://assets/textures/achievements/thnak you.png" 
	
}

func _ready() -> void:
	Global.player_died.connect(on_player_death)

func award(achievement: String) -> void:
	if Save.achievements_dict.has(achievement):
		if Save.achievements_dict.get(achievement) == false:
			Save.achievements_dict.set(achievement, true)
			
			if animation_player.is_playing() == false: 
				achievement_name.text = achievement
				achievement_icon.texture = load(achievement_to_icon_dict.get(achievement, "res://assets/textures/achievements/placeholder.png"))
				animation_player.play("achievement")
			else:
				achievement_name2.text = achievement
				achievement_icon2.texture = load(achievement_to_icon_dict.get(achievement, "res://assets/textures/achievements/placeholder.png"))
				animation_player2.play("achievement")
				
			Save.save_achievements()

func on_player_death() -> void:
	if Global.wegadolls_left == 1:
		Achievements.award("haha")
	if Global.lap == 1 and Global.wegadolls_left == 0 and Global.mode == "wcti":
		Achievements.award("idiot")
	if Global.lap == 2 and Global.wegadolls_left == 0 and Global.mode == "wcti":
		Achievements.award("so close, yet so far")

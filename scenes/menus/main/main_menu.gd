extends Control

@onready var settings = $Settings
@onready var buttons = $VBoxContainer
@onready var tips_text = $tips
@onready var gamemodes = $Gamemodes
@onready var recolorpedia: Control = $Recolorpedia
@onready var achievements_menu: Control = $"Achievements Menu"

func _play() -> void:
	gamemodes.show()
	buttons.hide()
	crossfade(true)

func _classic() -> void:
	if Save.progress_dict.get("beat classic tutorial") == true:
		get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")


func _the_idol() -> void:
	if Save.progress_dict.get("beat wcti tutorial") == true:
		get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/the idol tutorial/the idol tutorial.tscn")
	

func _credits() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main/mastermode credits test.tscn")

func on_gamemode_quit_pressed() -> void:
	gamemodes.hide()
	buttons.show()
	crossfade(false)

func _tutorial() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
	Global.tutorial = true

func _settings() -> void:
	settings.show()
	buttons.hide()
	crossfade(true)
	settings.animation_player.stop()
	settings.animation_player.play("new_animation")

func _recolorpedia() -> void:
	recolorpedia.position = Vector2(0, 0)
	position = Vector2(30000, 0)
	crossfade(true)
	Achievements.award("certified wega expert")

func _exit_recolorpedia() -> void:
	recolorpedia.position = Vector2(30000, 0)
	position = Vector2(0, 0)
	crossfade(false)

func _achievements() -> void:
	achievements_menu.position = Vector2(0, 0)
	position = Vector2(-30000, 0)
	crossfade(true)

func _exit_achievements() -> void:
	achievements_menu.position = Vector2(-30000, 0)
	position = Vector2(0, 0)
	crossfade(false)

func _quit() -> void:
	self.get_tree().quit()

func _on_close_button() -> void: #settings
	settings.hide()
	crossfade(false)
	buttons.show() 
	
@onready var bgm_no_drums: AudioStreamPlayer = $"No Drums"
@onready var bgm_drums: AudioStreamPlayer = $Drums

func crossfade(drums: bool) -> void:
	if drums == true:
		var tween = create_tween()
		tween.tween_property(bgm_no_drums, "volume_linear", 0.0, 1.0)
		var tween2 = create_tween()
		tween2.tween_property(bgm_drums, "volume_linear", 1.0, 1.0)
	else:
		var tween = create_tween()
		tween.tween_property(bgm_no_drums, "volume_linear", 1.0, 1.0)
		var tween2 = create_tween()
		tween2.tween_property(bgm_drums, "volume_linear", 0.0, 1.0)

func _ready() -> void:
	recolorpedia.dont_change_scene_to_main_menu = true
	recolorpedia.go_back_GO_BACK_LEAVE_GO_BACK_PLEASE_GO_BACK.connect(_exit_recolorpedia)
	SongCredits.show_song_credits("Does Not Bleed", "From: WEGAKILL OST", "By: somerandomguy21")
	StyleSFX.stop()
	randomize()
	tips_text.text = tips.pick_random()

var tips = ["In CLASSIC mode, Wega speeds up as you collect more Wegadolls.",
"In CLASSIC mode, styling on Wega enough will +ENRAGE him. Wega is faster when enraged, but only when you haven't collected many Wegadolls.",
"Juking Wega slows him down!",
"There's an unique style bonus for a +WEGACOMBO with 100 Wegadolls, but it's not as easy as one might think...",
"The hitboxes for the platform tiles are much more forgiving than you think!",
"Fun fact: you can reach WEGAKILL rank before collecting any Wegadolls!",
"In CLASSIC mode, your final score is your points multiplied by a special number that increases the less time you take to collect all Wegadolls.",
"Wega emits a colored light at all times! If the environment around you is changing color, he might be near.",
"It takes Wega exactly three seconds to run after you.",
"WATLM tomorrow",
"Hold LOOKBACK (Right Click) to look back. This can be especially useful when running from Wega.",
"Rorys can only spawn on Wegadolls.",
"The Rorys Explosion, provoked by punching Rorys, sends you backward in the direction of the camera and is a great mobility tool.",
"In THE IDOL, the first time you fall, Golden Sigma will save you! He will also always save you after a Rorys Explosion.",
"Golden Sigma will always save you after a Rorys Explosion!",
"You cannot run from Shoe Bench.",
"Super John can only hit you when he's going at high speed. To tell if he can hit you, look for his particles and for his unique dash animation!",
"Super John can be deflected with ATTACK (Left Click), reversing his velocity."
]

extends Control

## Wega's Challenge Godot Port

## most of the code here was stolen from a first person template lmao

@onready var settings = $Settings
@onready var buttons = $VBoxContainer
@onready var tips_text = $tips
@onready var gamemodes = $Gamemodes

func _play() -> void:
	gamemodes.show()
	buttons.hide()

func _classic() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")

func _the_idol() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/the idol/wctimain.tscn")


func on_gamemode_quit_pressed() -> void:
	gamemodes.hide()
	buttons.show()



func _tutorial() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial/tutorial.tscn")
	Global.tutorial = true

func _settings() -> void:
	settings.show()
	buttons.hide()

func _quit() -> void:
	self.get_tree().quit()

func _on_close_button() -> void:
	settings.hide()
	buttons.show() 

func _ready() -> void:
	randomize()
	tips_text.text = tips.pick_random()

var tips = ["In CLASSIC mode, Wega speeds up as you collect more Wegadolls.",
"In CLASSIC mode, styling on Wega enough will +ENRAGE him. Wega is faster when enraged, but only when you haven't collected many Wegadolls.",
"Juking Wega slows him down!",
"There's an unique style bonus for a +WEGACOMBO with 100 Wegadolls, but it's not as easy as one might think...",
"The hitboxes for the platform tiles are much more forgiving than you think!",
"Fun fact: you can reach WEGAKILL rank before collecting any Wegadolls!",
"Your final score is your points multiplied by a special number that gets smaller the more time you take to collect all Wegadolls.",
"Wega emits a colored light at all times! If the environment around you is changing color, he might be near.",
"It takes Wega exactly three seconds to run after you.",
"WATLM tomorrow",
"Hold LOOKBACK (Right Click) to look back. This can be especially useful when running from Wega",
"In THE IDOL, Rorys can only spawn on Wegadolls, so make sure to punch him with ATTACK (Left Click).",
"In THE IDOL, if you press ATTACK (Left Click) while near Rorys, you'll punch him, which stuns him and gives you a large boost of velocity.",
"In THE IDOL, the first time you fall, Golden Sigma will save you! He will also always save you after a Rorys Explosion.",
"In THE IDOL, Maltigi can be easily dodged by just walking forward.",
"In THE IDOL, punching Rorys (with ATTACK ATTACK (Left Click)) causes a Rorys Explosion, which gives you a large boost in velocity. If you fall due to a Rorys Explosion, Golden Sigma will save you!",
"You cannot run from Shoe Bench."
]

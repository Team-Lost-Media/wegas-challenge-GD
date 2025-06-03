extends Control

## Wega's Challenge Godot Port

## most of the code here was stolen from a first person template lmao

@onready var settings = $Settings
@onready var buttons = $VBoxContainer
@onready var tips_text = $tips


func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")

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

var tips = ["Wega speeds up as you collect more Wegadolls.",
"Styling on Wega enough will +ENRAGE him. Wega is faster when enraged, but only when you haven't collected many Wegadolls.",
"Juking Wega slows him down!",
"There's an unique style bonus for a +WEGACOMBO with 100 Wegadolls, but it's not as easy as one might think...",
"The hitboxes for the platform tiles are much more forgiving than you think!",
"Fun fact: you can reach WEGAKILL rank before collecting any Wegadolls!",
"Your final score is your points multiplied by a special number that gets smaller the more time you take to collect all Wegadolls.",
"Maltigi is in the game.",
"Wega emits a purple light at all times! If the environment around you is becoming purple, he might be near.",
"It takes Wega exactly three seconds to run after you.",
"WATLM tomorrow"
]

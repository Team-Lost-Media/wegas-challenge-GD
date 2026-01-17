extends Control

@onready var achievement_name: RichTextLabel = $TextureRect/name
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer

func _ready() -> void:
	Save.load_achievements()

func award(achievement: String) -> void:
	if Save.achievements_dict.has(achievement):
		if Save.achievements_dict.get(achievement) == false:
			Save.achievements_dict.set(achievement, true)
			achievement_name.text = achievement
			animation_player.play("achievement")
			Save.save_achievements()

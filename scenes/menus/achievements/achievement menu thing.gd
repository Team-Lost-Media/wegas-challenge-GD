extends Control

@export var achievement: String
@onready var darken: ColorRect = $Darken
@onready var winga: TextureRect = $Winga
@onready var achievement_name: RichTextLabel = $"Achievement Name"

var hovered: bool = false

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false


func _ready() -> void:
	if Save.achievements_dict.has(achievement):
		if Save.achievements_dict.get(achievement) == true:
			winga.show()
		else:
			darken.show()
	else:
		achievement_name.text = "ERROR YOU PUT IN THE WRONG STRING DIPSHIT"

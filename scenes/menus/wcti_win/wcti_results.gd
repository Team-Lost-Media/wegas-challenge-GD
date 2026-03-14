extends Control
@onready var label: Label = $Label

func _ready() -> void:
	Engine.time_scale = 1
	label.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1, 2)

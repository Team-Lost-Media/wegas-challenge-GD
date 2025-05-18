extends HSlider

@export var fov: bool
@export var sensitivity: bool

@onready var label: Label = $Label

func _physics_process(delta: float) -> void:
	if fov:
		label.text = str("FOV: ", str(value))
		SettingsHandler.fov = value
	if sensitivity:
		label.text = str("Sensitivity: ", str(value))
		SettingsHandler.sensitivity = value

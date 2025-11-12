extends HSlider

@export var fov: bool
@export var sensitivity: bool

@onready var fov_label: Label = $"../../Labels/FOV"
@onready var sensitivity_label: Label = $"../../Labels/Sensitivity"

func _physics_process(delta: float) -> void:
	if fov:
		fov_label.text = str("FOV: ", str(value))
		SettingsHandler.fov = value
	if sensitivity:
		sensitivity_label.text = str("Sensitivity: ", str(value))
		SettingsHandler.sensitivity = value

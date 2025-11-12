extends Panel

## Settings panel that does settings things

@onready var ResolutionOption = $Interactable/ResolutionOptionButton
@onready var FullscreenToggle = $Interactable/PanelContainer/FullscreenCheckBox
@onready var VSyncToggle = $Interactable/PanelContainer2/VSyncCheckBox
@onready var AudioSlider = $Interactable/SFXSlider
@onready var MusicSlider = $Interactable/BGMSlider
@onready var FOVSlider = $Interactable/FOVSlider
@onready var SensitivitySlider = $Interactable/SensitivitySlider


@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer

signal Closing

func _ready():
	# yeahhhh this is probably not the best way to do this
	for i in range(4):
		var text = ResolutionOption.get_item_text(i)
		var r = SettingsHandler._get_resolution_as_str()
		if text == r:
			ResolutionOption.selected = i
			break
	ResolutionOption.selected = SettingsHandler.get_value("selected resolution")
	FullscreenToggle.button_pressed = SettingsHandler.get_value("fullscreen")
	VSyncToggle.button_pressed = SettingsHandler.get_value("vsync")
	AudioSlider.value = SettingsHandler.get_value("sfx volume")
	MusicSlider.value = SettingsHandler.get_value("music volume")
	FOVSlider.value = SettingsHandler.get_value("fov")
	SensitivitySlider.value = SettingsHandler.get_value("sensitivity")

func _on_apply_settings() -> void:
	var resolution = ResolutionOption.get_item_text(ResolutionOption.selected)
	var fullscreen = FullscreenToggle.button_pressed
	var vsync = VSyncToggle.button_pressed
	resolution = resolution.split("x")
	resolution = [int(resolution[0]), int(resolution[1])]
	#print(resolution)
	SettingsHandler.SettingsDict = {"selected resolution": ResolutionOption.selected, "resolution": resolution, "vsync": vsync, "fullscreen": fullscreen, "sfx volume": AudioSlider.value, "music volume": MusicSlider.value, "fov" : FOVSlider.value, "sensitivity" : SensitivitySlider.value}
	
	SettingsHandler._apply_settings()
	SettingsHandler._save_settings()

func _on_close():
	Closing.emit()
	self.hide()

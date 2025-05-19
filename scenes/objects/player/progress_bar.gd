extends ProgressBar

@export var superjump: bool
@export var dash: bool

@onready var dash_cooldown: Timer = $"../DashCooldown"
@onready var superjump_cooldown: Timer = $"../SuperJumpCooldown"
@onready var label: Label = $Label #works for both the cooldowns's labels
@onready var player: CharacterBody3D = $".."

func _process(delta: float) -> void:
	if dash:
		max_value = dash_cooldown.wait_time
		value = dash_cooldown.time_left
		label.text = str("dashes left: ", str(player.dashes_left))
		match player.dashes_left:
			2:
				label.label_settings.font_color = Color8(0, 255, 0)
			1:
				label.label_settings.font_color = Color8(255, 128, 0)
			0:
				label.label_settings.font_color = Color8(255, 0, 0)
	
	if superjump:
		max_value = superjump_cooldown.wait_time
		value = superjump_cooldown.time_left

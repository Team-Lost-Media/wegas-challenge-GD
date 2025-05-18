extends ProgressBar

@onready var dash_cooldown: Timer = $"../DashCooldown"

func _process(delta: float) -> void:
	max_value = dash_cooldown.wait_time
	value = dash_cooldown.time_left

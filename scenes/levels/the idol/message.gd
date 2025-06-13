extends Label

@onready var display_timer: Timer = $DisplayTimer

var fadeout: bool = false

func _ready() -> void:
	modulate = Color.TRANSPARENT

func say(message: String, duration: float = 1.0) -> void:
	print("message: saying ", message)
	text = message
	modulate = Color.WHITE
	fadeout = false
	display_timer.start(duration)

func _process(delta: float) -> void:
	if fadeout == true:
		modulate = modulate.lerp(Color.TRANSPARENT, clamp(2 * delta, 0.0, 1.0))
	#if modulate.is_equal_approx(Color.TRANSPARENT):
	#	fadeout = false

func _on_display_timer_timeout() -> void:
	fadeout = true

func stop() -> void:
	modulate = Color.TRANSPARENT
	fadeout = false

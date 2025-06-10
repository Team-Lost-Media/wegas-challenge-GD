extends Label

func _ready() -> void:
	modulate = Color.TRANSPARENT

func say(message: String) -> void:
	text = message
	modulate = Color.WHITE

func _process(delta: float) -> void:
	if modulate != Color.TRANSPARENT:
		modulate = modulate.lerp(Color.TRANSPARENT, clamp(5 * delta, 0.0, 1.0))

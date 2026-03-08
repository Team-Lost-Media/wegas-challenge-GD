extends Label

var shake_intensity: float = 0
var shake_offset: Vector2 = Vector2(0, 0)
var shake_decay: float = 1

var pos: Vector2

func _ready() -> void:
	pos = global_position

func _physics_process(delta: float) -> void:
	shake_offset = Vector2(randf_range(-shake_intensity, shake_intensity),randf_range(-shake_intensity, shake_intensity))
	
	global_position = pos + shake_offset
	
	shake_intensity = clampf(shake_intensity - (10 * delta * shake_decay), 0, INF)

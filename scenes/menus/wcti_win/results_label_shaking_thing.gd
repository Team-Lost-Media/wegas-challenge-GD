extends RichTextLabel

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var particles: CPUParticles2D = $CPUParticles2D

var shake_intensity: float
var shake_decay: float = 1

var shake_offset: Vector2 = Vector2(0, 0)
var pos: Vector2 = Vector2(45.0, -230)

func _physics_process(delta: float) -> void:
	shake_intensity -= 10 * delta * shake_decay
	if shake_intensity > 1:
		shake_offset = Vector2(randf_range(-shake_intensity, shake_intensity),0)
	else:
		shake_offset = Vector2.ZERO
	
	global_position = pos + shake_offset

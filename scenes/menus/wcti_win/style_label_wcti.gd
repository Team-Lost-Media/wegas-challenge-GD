extends Control

@onready var style: RichTextLabel = $style
@onready var sfx: AudioStreamPlayer = $style/AudioStreamPlayer
@onready var fall_sfx: AudioStreamPlayer = $style/FallSFX
@onready var timer: Timer = $style/Timer
@onready var particles: CPUParticles2D = $CPUParticles2D
var number: int = 0

func anim() -> void:
	timer.start()
	var tween = create_tween()
	tween.tween_property(self, "number", Global.points, 4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func _on_timer_timeout() -> void:
	if style.text != str(Global.points):
		style.text = str(number)
		sfx.play()
		timer.wait_time /= 1.08
	else:
		timer.stop()
		fall_sfx.play()
		particles.emitting = true
		
		pos = style.position
		shaking = true
		shake_intensity = 5



var shaking: bool = false

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
	
	if shaking: style.position = pos + shake_offset

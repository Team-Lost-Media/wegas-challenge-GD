extends Control
@onready var results_label: RichTextLabel = $ResultsLabel
@onready var results_label_anim: AnimationPlayer = $ResultsLabel/AnimationPlayer
@onready var time: Control = $time
@onready var style: Control = $style

func _ready() -> void:
	Engine.time_scale = 1
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	
	time.position.x -= 1000
	style.position.x += 1000
	
	
	results_label_anim.play("show")
	await results_label_anim.animation_finished
	results_label.shake_intensity = 10
	results_label.shake_decay = 0.75
	results_label.sfx.play()
	results_label.particles.emitting = true
	
	await get_tree().create_timer(2).timeout
	var tween1 = create_tween()
	tween1.tween_property(time, "position:x", 0, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	var tween2 = create_tween()
	tween2.tween_property(style, "position:x", 0, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await get_tree().create_timer(2).timeout
	time.anim()
	
	await get_tree().create_timer(3).timeout
	style.anim()

extends Control
@onready var results_label: RichTextLabel = $ResultsLabel
@onready var results_label_anim: AnimationPlayer = $ResultsLabel/AnimationPlayer
@onready var time: Control = $time
@onready var style: Control = $style

@onready var beat_roll: RigidBody2D = $"beat roll"
@onready var did_you_beat_the_roll: Label = $"yes i beat the roll gimme orange line now"
@onready var yes_i_beat_the_roll_gimme_orange_line_now: AnimationPlayer = $"yes i beat the roll gimme orange line now/AnimationPlayer"
@onready var line: ColorRect = $line
@onready var line_anim: AnimationPlayer = $line/line_anim

@onready var quit_go_away: Label = $"QUIT GO AWAY"

func _ready() -> void:
	Engine.time_scale = 1
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	
	time.position.x -= 1000
	style.position.x += 1000
	beat_roll.position.y = 1220
	
	did_you_beat_the_roll.modulate.a = 0
	line.hide()
	
	quit_go_away.modulate.a = 0
	
	results_label_anim.play("show")
	await results_label_anim.animation_finished
	results_label.shake_intensity = 10
	results_label.shake_decay = 0.75
	results_label.sfx.play()
	results_label.particles.emitting = true
	
	await get_tree().create_timer(2).timeout
	var tween1 = create_tween()
	tween1.tween_property(time, "position:x", 100, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var tween2 = create_tween()
	tween2.tween_property(style, "position:x", -100, 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	await get_tree().create_timer(1.5).timeout
	time.anim()
	
	await get_tree().create_timer(3.3).timeout
	style.anim()
	
	await get_tree().create_timer(5).timeout
	var tween3 = create_tween()
	tween3.tween_property(beat_roll, "position:y", 864.0, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await get_tree().create_timer(1.5).timeout
	
	if Global.credits_cleared:
		did_you_beat_the_roll.text = "YES"
		line.color = Color.ORANGE
	else:
		did_you_beat_the_roll.text = "NO"
		line.color = Color.GREEN
	yes_i_beat_the_roll_gimme_orange_line_now.play("new_animation")
	await get_tree().create_timer(0.3).timeout
	beat_roll.freeze = false
	beat_roll.linear_velocity = Vector2(-500, -1400)
	beat_roll.angular_velocity = 10
	await get_tree().create_timer(0.3).timeout
	line_anim.play("new_animation")
	line.show()
	quittable = true
	
	await get_tree().create_timer(2).timeout
	var tween4 = create_tween()
	tween4.tween_property(quit_go_away, "modulate:a", 1, 1)


var quittable: bool = false
func _process(delta: float) -> void:
	if quittable:
		if Input.is_action_just_pressed("escape"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")

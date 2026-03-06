extends Control

@onready var camera: Camera2D = $Camera2D

@onready var label: RichTextLabel = $RichTextLabel2
@onready var label2: RichTextLabel = $RichTextLabel3
@onready var text_sound: AudioStreamPlayer = $"text sound"
@onready var glitch_sound: AudioStreamPlayer = $"glitch sound"
@onready var final_sound: AudioStreamPlayer = $"final sound"

var shake: float = 10
var shake_decay: float = 1

func _ready() -> void:
	label.hide()
	label2.hide()
	anim()

func anim() -> void:
	await get_tree().create_timer(3.0).timeout
	label.show()
	label.text = "[i]GOLDEN SIGMA HAS ESCAPED,"
	text_sound.play()
	await get_tree().create_timer(1.1).timeout
	glitch_sound.play()
	label.text = "[i]!OLDEN S#GMA HAS ESCAPED,"
	await get_tree().create_timer(0.1).timeout
	label.text = "[i]!OL?EN S#GM@ HAS ESCAPED,"
	await get_tree().create_timer(0.1).timeout
	label.text = "[i]!#&?E- S#G%@ HAS ESCAPED,"
	await get_tree().create_timer(0.1).timeout
	label.text = "[i]!#&?@-$&#-%@ HAS ESCAPED,"
	await get_tree().create_timer(0.1).timeout
	label.hide()
	label2.show()
	await get_tree().create_timer(2.5).timeout
	label2.hide()
	label.show()
	label.text = "[i]WITH THE IDOL IN TOW."
	text_sound.play()
	await get_tree().create_timer(1.0).timeout
	final_sound.play()
	await get_tree().create_timer(0.7, true, false, true).timeout
	shake = 10
	shake_decay = 1.5
	await get_tree().create_timer(1.9 - 0.7, true, false, true).timeout
	shake = 15
	shake_decay = 1.2
	await get_tree().create_timer(3.6 - 1.9 - 0.7, true, false, true).timeout
	var tween = create_tween()
	tween.tween_property(self, "shake", shake_decay + 30, 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await final_sound.finished
	get_tree().change_scene_to_file("res://scenes/levels/the idol/wcti credits.tscn")


var glitch_sfx_times: Array = [
	0.657,
	0.736,
	0.830,
	0.980,
	1.244,
	1.602,
	1.642,
	1.681,
	1.721,
	1.760,
	1.799,
	1.839,
	1.879,
	2.340,
	2.531,
	2.699,
	2.849,
	2.960,
	3.059,
	3.119,
	3.187,
	3.226,
	3.265,
	3.305,
	3.344,
	3.384,
	3.423,
	3.462,
	3.583,
	3.733,
	3.915,
	4.133,
	4.401,
	4.717,
	99999
]
func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if final_sound.get_playback_position() + AudioServer.get_time_since_last_mix() > glitch_sfx_times.get(0):
		glitch_sfx_times.remove_at(0)
		change_text()
		change_text()
	

func _physics_process(delta: float) -> void:
	shake -= 10 * delta * shake_decay
	if shake > 1:
		camera.offset = Vector2(randf_range(0, shake), randf_range(0, shake))
	else:
		camera.offset = Vector2(0, 0)

func change_text(character: int = -1, duration: float = 0.1):
	var text: String = label.get_parsed_text()
	if character == -1: character = randi_range(0, text.length() - 1)
	
	var letters: String = "&$!@*#%"
	var random_letter: String = letters[randi_range(0, letters.length() - 1)]
	
	label.text = "[i]" + text.substr(0, character) + random_letter + text.substr(character + 1)
	
	await get_tree().create_timer(duration).timeout
	label.text = "[i]" + text

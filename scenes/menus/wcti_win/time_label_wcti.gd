extends Control

@onready var timetext: RichTextLabel = $timetext
@onready var time: RichTextLabel = $time
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	time.text = Global.saved_time_as_string

func anim() -> void:
	for i in time.text.length():
		await get_tree().create_timer(0.3).timeout
		time.visible_characters += 1
		sfx.play()

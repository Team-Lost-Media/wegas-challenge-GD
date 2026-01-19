extends Control

@onready var fireball: Control = $Fireball
@onready var fireball_audio1: AudioStreamPlayer = $Fireball/AudioStreamPlayer
@onready var fireball_audio2: AudioStreamPlayer = $Fireball/AudioStreamPlayer2
@onready var super_john: Control = $"Super John"
@onready var super_john_audio: AudioStreamPlayer = $"Super John/AudioStreamPlayer"

func play_damage_fx(id: String):
	match id:
		"fireball":
			fireball.modulate = Color.WHITE
			fireball_audio2.play()
			var tween = create_tween()
			tween.tween_property(fireball, "modulate:a", 0, 1.0)
			await get_tree().create_timer(0.3)
			fireball_audio1.play()
		"super john":
			super_john.modulate = Color.from_string("ffffffbb", Color.WHITE)
			super_john_audio.play()
			var tween = create_tween()
			tween.tween_property(super_john, "modulate:a", 0, 1.0)

func _ready() -> void:
	show()

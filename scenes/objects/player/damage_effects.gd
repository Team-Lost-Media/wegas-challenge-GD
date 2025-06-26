extends Control

@onready var fireball: Control = $Fireball
@onready var fireball_audio1: AudioStreamPlayer = $Fireball/AudioStreamPlayer
@onready var fireball_audio2: AudioStreamPlayer = $Fireball/AudioStreamPlayer2

func play_damage_fx(id: String):
	match id:
		"fireball":
			fireball.modulate = Color.WHITE
			fireball_audio2.play()
			var tween = create_tween()
			tween.tween_property(fireball, "modulate:a", 0, 1.0)
			await get_tree().create_timer(0.3)
			fireball_audio1.play()

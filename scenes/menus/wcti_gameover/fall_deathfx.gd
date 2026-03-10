extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func anim() -> void:
	audio_stream_player.play()
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 1.0)
	
	await get_tree().create_timer(0.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(label, "modulate:a", 0.6, 1.0)

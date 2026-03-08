extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func anim() -> void:
	audio_stream_player.play()
	sprite.show()
	sprite.play("default")

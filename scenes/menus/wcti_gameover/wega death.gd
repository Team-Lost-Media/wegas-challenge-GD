extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	texture_rect.position.y = -1500

func anim() -> void:
	print("wega")
	audio_stream_player.play()
	var tween = create_tween()
	tween.tween_property(texture_rect, "position:y", 0, 2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.2).timeout
	audio_stream_player.play()
	await get_tree().create_timer(0.1).timeout
	audio_stream_player.play()
	await get_tree().create_timer(0.05).timeout
	audio_stream_player.play()

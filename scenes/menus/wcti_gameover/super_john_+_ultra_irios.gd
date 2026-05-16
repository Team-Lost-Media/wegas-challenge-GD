extends Control
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

func anim() -> void:
	video_stream_player.play()

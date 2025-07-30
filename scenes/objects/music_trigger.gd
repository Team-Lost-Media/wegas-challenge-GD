extends Area3D

@export var bgm_node: AudioStreamPlayer
@export var bgm: AudioStream
@export var single_use: bool = true
@export_group("Credits")
@export var enable_song_credits: bool = false
@export var title: String
@export var author: String

var used = false

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if single_use:
			if used == false:
				used = true
				bgm_node.stream = bgm
				bgm_node.play()
				if enable_song_credits: SongCredits.show_song_credits(title, author)
		else:
				bgm_node.stream = bgm
				bgm_node.play()
				if enable_song_credits: SongCredits.show_song_credits(title, author)

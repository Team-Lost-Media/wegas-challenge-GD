extends Area3D

@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var default_save: Texture2D
@export var rorys_save: Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var saves_left: Label = $"TextureRect/saves left"

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if default_save: texture_rect.texture = default_save
		if body.saveable_fall == true:
			if rorys_save: texture_rect.texture = rorys_save
			body.saveable_fall = false
			i_will_save_you(body, false)
		elif body.fall_saves > 0:
			body.fall_saves -= 1
			i_will_save_you(body)
		else:
			Global.died_to = "fall"
			get_tree().change_scene_to_file(death_scene)

func i_will_save_you(body: Node3D, show_saves_left = true) -> void:
	if show_saves_left == false:
		saves_left.hide()
	else:
		saves_left.show()
		saves_left.text = str(body.fall_saves)
	body.velocity.y = 50
	texture_rect.modulate = Color.WHITE
	audio_stream_player.play()
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate", Color.TRANSPARENT, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#note: DONT MAKE THIS USE collision.disabled!!!!!!!!!!!!!!!!! collision.disabled IS BROKEN!!!!! I DONT KNOW WHY BUT IT DOESNT DO ANYTHING JUST USE THIS INSTEAD
	var shit = body.collision_mask
	body.collision_mask = 0
	await get_tree().create_timer(0.5).timeout
	body.collision_mask = shit

extends Area3D

@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var saveable = true
@export var default_save: Texture2D
@export var rorys_save: Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var saves_left: Label = $"TextureRect/saves left"

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if saveable:
			if default_save: texture_rect.texture = default_save
			if body.saveable_fall == true:
				if rorys_save: texture_rect.texture = rorys_save
				body.saveable_fall = false
				i_will_save_you(body)
			else:
				Global.health -= 100
				if Global.health < 0:
					Global.died_to = "fall"
					Global.player_died.emit()
					get_tree().change_scene_to_file(death_scene)
				else:
					i_will_save_you(body)
				
		else:
			Global.died_to = "fall"
			Global.player_died.emit()
			await get_tree().process_frame
			get_tree().change_scene_to_file(death_scene)
			

func i_will_save_you(body: Node3D) -> void:
	body.this_timer_only_exists_to_prevent_a_bug_where_if_you_dash_right_after_being_saved_you_clip_through_the_death_area.start()
	body.velocity.y = 50
	texture_rect.modulate = Color.WHITE
	audio_stream_player.play()
	Achievements.award("thnak you.")
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate", Color.TRANSPARENT, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#note: DONT MAKE THIS USE collision.disabled!!!!!!!!!!!!!!!!! collision.disabled IS BROKEN!!!!! I DONT KNOW WHY BUT IT DOESNT DO ANYTHING JUST USE THIS INSTEAD
	var shit = body.collision_mask
	body.collision_mask = 0
	await get_tree().create_timer(0.5).timeout
	body.collision_mask = shit

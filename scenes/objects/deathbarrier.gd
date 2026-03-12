extends Area3D

@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
@export var saveable = true
@export var damage: float = 100.5
#@export var default_save: Texture2D
#@export var rorys_save: Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var save_sfx: AudioStreamPlayer = $"i will save you"
@onready var fall_sfx: AudioStreamPlayer = $"i will not save you"

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if saveable:
			if body.saveable_fall == true:
				body.saveable_fall = false
				i_will_save_you(body, true)
				Achievements.award("thnak you.")
			else:
				Global.health -= damage
				if Global.health < 0:
					Global.died_to = "fall"
					Global.player_died.emit()
					if death_scene != "": get_tree().change_scene_to_file(death_scene)
				else:
					body.health_label.shake_intensity = 10
					i_will_save_you(body, false)
				
		else:
			Global.died_to = "fall"
			Global.player_died.emit()
			await get_tree().process_frame
			if death_scene != "": get_tree().change_scene_to_file(death_scene)
			

var tween: Tween
func i_will_save_you(body: Node3D, anim: bool = true) -> void:
	body.this_timer_only_exists_to_prevent_a_bug_where_if_you_dash_right_after_being_saved_you_clip_through_the_death_area.start()
	body.velocity.y = 50
	
	
	if anim:
		texture_rect.modulate = Color.WHITE
		save_sfx.play()
		if tween: tween.stop()
		tween = create_tween()
		tween.tween_property(texture_rect, "modulate", Color.TRANSPARENT, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		fall_sfx.play()
	
	#note: DONT MAKE THIS USE collision.disabled!!!!!!!!!!!!!!!!! collision.disabled IS BROKEN!!!!! I DONT KNOW WHY BUT IT DOESNT DO ANYTHING JUST USE THIS INSTEAD
	var shit = body.collision_mask
	body.collision_mask = 0
	await get_tree().create_timer(0.5).timeout
	body.collision_mask = shit

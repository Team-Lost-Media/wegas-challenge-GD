extends RigidBody3D

var death_scene
var damage: float
@onready var thy_end_is_now: Timer = $"THY END IS NOW"
@onready var close_call_cooldown: Timer = $CloseCallCooldown
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
var close_call = false

func _process(delta: float) -> void:
	pass
	#wposition += speed * rotation * delta

func _on_death_area_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		Global.health -= damage
		body.health_label.shake_intensity = 5
		close_call = false
		body.damage_effects.play_damage_fx("fireball")
		if Global.health <= 0:
			Global.died_to = "ultra irios fireball"
			Global.player_died.emit()
			get_tree().change_scene_to_file(death_scene)


func THY_END_IS_NOW() -> void:
	queue_free()


func _on_close_call_area_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter and close_call_cooldown.is_stopped():
		close_call = true


func _on_close_call_area_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter and close_call == true:
		Global.points += 200
		Global.style = "+CLOSE CALL"
		Global.health += 200/20#handlestylehealthregen
		audio.play()
		StyleSFX.play_style_sfx(0, true)
		close_call = false
		close_call_cooldown.start()

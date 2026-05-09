extends Area3D

@export var bgm_node: AudioStreamPlayer

var used = false

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if used == false:
			used = true
			var tween = create_tween()
			tween.tween_property(bgm_node, "volume_linear", 0.0, 2.0)

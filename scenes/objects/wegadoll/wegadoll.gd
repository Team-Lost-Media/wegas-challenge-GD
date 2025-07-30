extends Node3D

@onready var wegadoll: MeshInstance3D = $WegaDoll

signal collected

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if body.disable_collecting_wegadolls == false:
			collected.connect(Global.collect_wegadoll)
			collected.emit()
			Global.points += 1
			queue_free()

var cheat = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cheat") and cheat == true:
		collected.connect(Global.collect_wegadoll)
		collected.emit()
		Global.points += 1
		queue_free()

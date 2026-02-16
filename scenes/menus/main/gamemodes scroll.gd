extends Panel

@onready var modes_container: VBoxContainer = $TextureRect/VBoxContainer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 4:
			modes_container.position.y += 25
		if event.button_index == 5:
			modes_container.position.y -= 25
	modes_container.position.y = clampf(modes_container.position.y, -400, 0)

extends Panel

@onready var modes_container: VBoxContainer = $TextureRect/VBoxContainer
@onready var classic: Button = $TextureRect/VBoxContainer/Classic
@onready var the_idol: Button = $"TextureRect/VBoxContainer/The Idol"
@onready var thing_to_show_while_the_idol_is_locked: Control = $"TextureRect/VBoxContainer/The Idol/thing to show while the idol is locked"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 4:
			modes_container.position.y += 25
		if event.button_index == 5:
			modes_container.position.y -= 25
	modes_container.position.y = clampf(modes_container.position.y, -400, 0)

func _process(delta: float) -> void:
	if Save.progress_dict.get("beat classic") == true:
		the_idol.disabled = false
		thing_to_show_while_the_idol_is_locked.hide()
	else:
		the_idol.disabled = true
		thing_to_show_while_the_idol_is_locked.show()

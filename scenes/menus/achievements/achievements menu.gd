extends Control

signal go_back_GO_BACK_LEAVE_GO_BACK_PLEASE_GO_BACK_TWO

@export var dont_change_scene_to_main_menu: bool = false
@onready var achievements: Control = $Achievements

var open: bool = false

func _on_go_back_pressed() -> void:
	go_back_GO_BACK_LEAVE_GO_BACK_PLEASE_GO_BACK_TWO.emit()
	if dont_change_scene_to_main_menu == false:
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")

func _process(delta: float) -> void:
	'''
	#region achievement hovering
	for child in achievements.get_children():
		if child is Control:
			if child.hovered:
				var tween = create_tween()
				tween.tween_property(child, "position:x", 500.0, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			else:
				var tween = create_tween()
				tween.tween_property(child, "position:x", 600, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#endregion
'''

func _input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if open:
				if event.button_index == 4:
					achievements.position.y += 35
				if event.button_index == 5:
					achievements.position.y -= 35
		achievements.position.y = clampf(achievements.position.y, -3600, 0)

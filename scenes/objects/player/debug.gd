extends Label

func _process(delta: float) -> void:
	text = str("style_meter_value = ", str($"../PanelContainer/StyleBar".style_meter_value), "\n", "wegadoll_combo = ", str(Global.wegadoll_combo), "\n", "wegadoll_combo_timer.is_stopped() = ", str(Global.wegadoll_combo_timer.is_stopped()), "\n", "coyote = ", str($"..".coyote))

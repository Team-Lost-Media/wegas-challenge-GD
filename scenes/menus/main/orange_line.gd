extends ColorRect

var green_line: bool = Save.progress_dict.get("beat wcti")
var orange_line: bool = Save.progress_dict.get("beat wcti orange line")

func _ready() -> void:
	await get_tree().process_frame
	green_line = Save.progress_dict.get("beat wcti")
	orange_line = Save.progress_dict.get("beat wcti orange line")
	if orange_line:
		show()
		color = Color.ORANGE
	elif green_line:
		show()
		color = Color.GREEN
	else:
		hide()

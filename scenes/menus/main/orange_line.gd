extends ColorRect

var green_line: bool = Save.progress_dict.get("beat wcti")
var orange_line: bool = Save.progress_dict.get("beat wcti orange line")

func _ready() -> void:
	if orange_line:
		show()
		color = Color.ORANGE
	elif green_line:
		show()
		color = Color.GREEN
	else:
		hide()

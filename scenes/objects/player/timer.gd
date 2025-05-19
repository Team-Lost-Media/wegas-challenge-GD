extends Label

var totaltime_seconds: float
var totaltime_minutes: int



func _on_timer_timeout() -> void:
	totaltime_seconds += 0.01
	if totaltime_seconds > 59.99:
		totaltime_minutes += 1
		totaltime_seconds = 0

func _process(delta: float) -> void:
	text = str(totaltime_minutes, ":", snapped(totaltime_seconds, 0.01))
	

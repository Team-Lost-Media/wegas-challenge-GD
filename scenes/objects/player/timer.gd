extends Label

var time: float
var totaltime_seconds: float
var totaltime_minutes: int


func _on_timer_timeout() -> void:
	pass
	#one_centisecond_passed.connect(Global.one_centisecond_has_passed)
	#one_centisecond_passed.emit()
	#totaltime_seconds += 0.01
	#if totaltime_seconds > 59.99:
	#	totaltime_minutes += 1
	#	totaltime_seconds = 0
# OLD CODE ^^^^^^^^
# i dont use this anymore because it's inconsistent, and using delta in _process() is better
#also the first section is broken because one_centisecond_passed doesnt exist anymore

func _process(delta: float) -> void:
	time += delta
	if totaltime_seconds > 59.99:
		totaltime_minutes += 1
		totaltime_seconds = 0
	else:
		totaltime_seconds = time
	text = str(totaltime_minutes, ":", snapped(totaltime_seconds, 0.001))
	Global.time_as_string = str(totaltime_minutes, ":", snapped(totaltime_seconds, 0.001))
	Global.time_in_seconds = time
	

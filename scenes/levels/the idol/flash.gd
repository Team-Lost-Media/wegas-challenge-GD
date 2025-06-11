extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var duration: float
var change_color = false

## Flashes in the foreground with color [code]color[/code] for [code]duration[/code] seconds.
func flash(color: Color, duration_in_seconds: float = 1.0) -> void:
	color_rect.color = color
	duration = duration_in_seconds
	change_color = true
	await get_tree().create_timer(duration).timeout
	change_color = false



func _process(delta: float) -> void:
	if change_color == true:
		var tween = create_tween()
		tween.tween_property(color_rect, "color", Color.TRANSPARENT, duration)
	
	# DELETE THIS ONCE YOU FIGURE OUT HOW TO MAKE FLASHES FOR A SPECIFIC DURATION OF TIME
	#if color_rect.color != Color.TRANSPARENT:
	#	color_rect.color = color_rect.color.lerp(Color.TRANSPARENT, clamp(1.0 * delta, 0.0, 1.0))

func _on_duration_timer_timeout() -> void:
	change_color = false

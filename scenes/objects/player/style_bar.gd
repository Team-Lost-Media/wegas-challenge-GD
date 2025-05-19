extends VBoxContainer

@onready var rank_label: Label = $RankLabel
@onready var style_label: Label = $StyleLabel
@onready var points_label: Label = $PointsLabel

var style_meter_value: float
var style_meter_rank: String

var last_points: int

func _process(delta: float) -> void:
	points_label.text = str(Points.points)
	
	
	if Points.style != "none":
		style_label.text = Points.style
		style_meter_value += Points.points - last_points
		Points.style = "none"
		perform_fx()
	
	last_points = Points.points
	
	if points_label.label_settings.font_color != Color8(255, 255, 255):
		print("changing text to white")
		print(points_label.label_settings.font_color)
		points_label.label_settings.font_color = points_label.label_settings.font_color.lerp(Color8(255, 255, 255), 0.8 * delta)
	
	style_meter()

func perform_fx() -> void:
	points_label.label_settings.font_color = Color8(160, 43, 255)

func style_meter() -> void:
	
	$"../../Debug".text = str(style_meter_value)
	
	if style_meter_value >= 700:
		style_meter_rank = "SHOE BENCH"
	elif style_meter_value >= 400:
		style_meter_rank = "wegAMAZING"
	elif style_meter_value >= 200:
		style_meter_rank = "BEAR5"
	else:
		style_meter_rank = "NONE"
	
	match style_meter_rank:
		"SHOE BENCH":
			rank_label.text = "SHOE BENCH"
			rank_label.label_settings.font_color = Color8(255, 0, 0)
			rank_label.label_settings.outline_color = Color8(255, 255, 0)
		"wegAMAZING":
			rank_label.text = "wegAMAZING"
			rank_label.label_settings.font_color = Color8(66, 0, 123)
			rank_label.label_settings.outline_color = Color8(128, 0, 255)
		"BEAR5":
			rank_label.text = "BEAR5"
			rank_label.label_settings.font_color = Color8(0, 0, 255)
			rank_label.label_settings.outline_color = Color8(0, 0, 0)
		"NONE":
			rank_label.text = ""
			rank_label.label_settings.font_color = Color8(0, 0, 0)
			rank_label.label_settings.font_color = Color8(0, 0, 0)

func _on_timer_timeout() -> void:
	if style_meter_value > 0:
		if style_meter_value > 800:
			style_meter_value -= 1.2
		else:
			style_meter_value -= 0.4

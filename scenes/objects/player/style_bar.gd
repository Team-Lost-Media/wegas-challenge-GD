extends VBoxContainer

@onready var rank_label: Label = $RankLabel
@onready var style_label: Label = $StyleLabel
@onready var points_label: Label = $PointsLabel
@onready var rank_bar: ProgressBar = $RankBar

var style_meter_value: float
var style_meter_rank: String

var last_points: int

func _ready() -> void:
	Global.wegadoll_collected.connect(perform_wegacombo_fx)

func _process(delta: float) -> void:
	points_label.text = str(Global.points)
	
	
	if Global.wegadoll_combo > 20:
		if Global.wegadoll_combo > 99:
			style_label.text = "+ULTRAWEGACOMBO"
		else:
			style_label.text = str("+WEGACOMBO ", Global.wegadoll_combo, "X")
		
	
	if Global.style != "none":
		style_label.text = Global.style
		style_meter_value += Global.points - last_points
		Global.style = "none"
		perform_fx()
	
	
	
	last_points = Global.points
	
	if points_label.label_settings.font_color != Color8(255, 255, 255):
		#print("changing text to white")
		#print(points_label.label_settings.font_color)
		points_label.label_settings.font_color = points_label.label_settings.font_color.lerp(Color8(255, 255, 255), 0.8 * delta)
	
	style_meter()

func perform_fx() -> void:
	points_label.label_settings.font_color = Color8(160, 43, 255)

func perform_wegacombo_fx() -> void:
	if Global.wegadoll_combo > 20:
		points_label.label_settings.font_color = points_label.label_settings.font_color.blend(Color8(215, 158, 255))


func style_meter() -> void: #executed every frame
	
	rank_bar.value = style_meter_value
	
	if style_meter_value >= 700: #change style rank and the bar's max and min values
		style_meter_rank = "SHOE BENCH"
		rank_bar.max_value = 1200
		rank_bar.min_value = 700
		rank_bar.show()
	elif style_meter_value >= 400:
		style_meter_rank = "wegAMAZING"
		rank_bar.max_value = 700
		rank_bar.min_value = 400
		rank_bar.show()
	elif style_meter_value >= 200:
		style_meter_rank = "BEAR5"
		rank_bar.max_value = 400
		rank_bar.min_value = 200
		rank_bar.show()
	else:
		style_meter_rank = "NONE"
		rank_bar.hide()
	
	match style_meter_rank: #change the style rank colors
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
			if style_meter_value > 1200:
				style_meter_value -= 3.6
			else:
				style_meter_value -= 1.2
		else:
			style_meter_value -= 0.4
	

extends VBoxContainer

@onready var rank_label: Label = $RankLabel
@onready var style_label: Label = $StyleLabel
@onready var points_label: Label = $PointsLabel
@onready var rank_bar: ProgressBar = $RankBar

@export_category("Colors")
#it says color8() is deprecated but how else am i gonna @export these
@export var wegakill: Color = Color8(191, 0, 255)
@export var wegakill_outline: Color = Color8(132, 0, 255)
@export var shoe_bench: Color = Color8(255, 0, 0)
@export var shoe_bench_outline: Color = Color8(255, 255, 0)
@export var albert: Color = Color8(255, 128, 255)
@export var albert_outline: Color = Color8(69, 34, 69)
@export var bear5: Color = Color8(0, 0, 255)
@export var bear5_outline: Color = Color8(0, 0, 0)

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
	
	if points_label.label_settings.font_color != Color.from_rgba8(255, 255, 255):
		#print("changing text to white")
		#print(points_label.label_settings.font_color)
		points_label.label_settings.font_color = points_label.label_settings.font_color.lerp(Color.from_rgba8(255, 255, 255), 0.8 * delta)
	
	style_meter(delta)

func perform_fx() -> void:
	points_label.label_settings.font_color = Color.from_rgba8(160, 43, 255)

func perform_wegacombo_fx() -> void:
	if Global.wegadoll_combo > 20:
		points_label.label_settings.font_color = points_label.label_settings.font_color.blend(Color.from_rgba8(215, 158, 255))


func style_meter(delta: float) -> void: #executed every frame
	
	rank_bar.value = style_meter_value
	
	#change style rank and the bar's max and min values
	if style_meter_value >= 1000:
		style_meter_rank = "WEGAKILL"
		rank_bar.max_value = 2000
		rank_bar.min_value = 1000
		rank_bar.show()
	elif style_meter_value >= 700: 
		style_meter_rank = "SHOE BENCH"
		rank_bar.max_value = 1000
		rank_bar.min_value = 700
		rank_bar.show()
	elif style_meter_value >= 400:
		style_meter_rank = "ALBERT(SCARY!!)"
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
		"WEGAKILL":
			rank_label.text = "WEGAKILL"
			rank_label.label_settings.font_color = wegakill
			rank_label.label_settings.outline_color = wegakill_outline
			rank_label.label_settings.outline_size = 20
		"SHOE BENCH":
			rank_label.text = "SHOE BENCH"
			rank_label.label_settings.font_color = shoe_bench
			rank_label.label_settings.outline_color = shoe_bench_outline
			rank_label.label_settings.outline_size = 10
		"ALBERT(SCARY!!)":
			rank_label.text = "ALBERT(SCARY!!)"
			rank_label.label_settings.font_color = albert
			rank_label.label_settings.outline_color = albert_outline
			rank_label.label_settings.outline_size = 10
		"BEAR5":
			rank_label.text = "BEAR5"
			rank_label.label_settings.font_color = bear5
			rank_label.label_settings.outline_color = bear5_outline
			rank_label.label_settings.outline_size = 10
		"NONE":
			rank_label.text = ""
			rank_label.label_settings.font_color = Color.from_rgba8(0, 0, 0)
			rank_label.label_settings.font_color = Color.from_rgba8(0, 0, 0)
	
	
	if x_seconds_passed(delta, 0.01) == true:
		if style_meter_value > 0:
			if style_meter_value > 1000:
				style_meter_value -= 2.4
			elif style_meter_value > 700:
				style_meter_value -= 0.8
			else:
				style_meter_value -= 0.4

func _on_timer_timeout() -> void:
	pass
	#if style_meter_value > 0:
	#	if style_meter_value > 1200:
	#		style_meter_value -= 3.6
	#	else:
	#		style_meter_value -= 0.4
# this uses a 0.01 second timer, which is bad
# only re-add this if the implementation of delta fucks everything

func x_seconds_passed(delta: float, x: float):
	var previous_time_in_seconds: int
	var time: float
	previous_time_in_seconds = snapped(time, x)
	time += delta
	
	if snapped(time, x) > previous_time_in_seconds:
		return true
	else:
		return false

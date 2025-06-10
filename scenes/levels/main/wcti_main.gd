extends Node3D

@onready var group_of_wegas: Node3D = $"group of wegas"
@onready var label: Label = $GUI/Label
@onready var message: Label = $GUI/Message
@onready var sfx: AudioStreamPlayer = $SFX
@onready var wexecution: AudioStreamPlayer = $WEXECUTION
@onready var wegafadence: AudioStreamPlayer = $WEGAFADENCE

@onready var wegasleft = group_of_wegas.get_child_count()

@onready var so_retro: Node3D = $"So Retro!"
@onready var so_retro_area: Area3D = $"So Retro!/Area3D"
@onready var wega: Sprite3D = $Wega
@onready var maltigi: Sprite3D = $Maltigi
@onready var player: PlayerCharacter = $Player
@onready var wegafadence_beat: RhythmNotifier = $"wegafadence beat" #emits a signal every bar
var wegafadence_bars: int = 0
@onready var gridmap: GridMap = $Main/GridMap
@onready var lap_2_gridmap: GridMap = $Main/Lap2GridMap

var delta_but_the_one_i_used_for_the_transition_to_lap_2: float

func _ready() -> void:
	Global.points = 0
	Global.style = "none"
	Global.wegadolls_left = wegasleft
	Global.max_wegadolls = wegasleft
	wegafadence_beat.running = false
	message.text = ""
	#maltigi.stop()
	lap_2_gridmap.position.y = -10
	lap_2_gridmap.hide()

func _process(delta: float) -> void:
	delta_but_the_one_i_used_for_the_transition_to_lap_2 = delta
	
	if wegasleft != group_of_wegas.get_child_count():
		sfx.play()
		Global.wegadolls_left = group_of_wegas.get_child_count()
	wegasleft = group_of_wegas.get_child_count()
	label.text = "wegas left: %s" % wegasleft
	
	if wegasleft <= 100:
		if maltigi.enabled == false:
			maltigi.start()
			message.say("MALTIGI IS COMING")
	
	if wegasleft <= 0:
		so_retro_area.monitoring = true
		so_retro.show()
		wega.enabled = false
		wega.kill = false
		wega.hide()
		maltigi.enabled = false
		maltigi.kill = false
		maltigi.hide()
		Global.timer_stopped = true
		player.fade_out_gui(delta)
		label.modulate = label.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
		wexecution.pitch_scale = lerp(wexecution.pitch_scale, 0.5, clamp(0.6 * delta, 0.0, 1.0))
		wexecution.volume_linear = lerp(wexecution.volume_linear, 0.0, clamp(0.6 * delta, 0.0, 1.0))
		
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	so_retro.rotation.y -= PI * 2 * delta


func _on_so_retro_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		Global.timer_stopped = false
		label.modulate = Color.WHITE
		player.style_panel.modulate = Color.WHITE
		player.superjump_cooldown_bar.modulate = Color.WHITE
		player.dash_cooldown_bar.modulate = Color.WHITE
		
		#change to lap 2
		#blahblahblah idk how ill do this lmao ill figure something out
		lap_2_gridmap.show()
		lap_2_gridmap.position.y = lerp(lap_2_gridmap.position.y, 0, clamp(5 * delta_but_the_one_i_used_for_the_transition_to_lap_2, 0.0, 1.0))
		
		#currently used as a placeholder
		#get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn") #win


func _on_rhythm_notifier_beat(current_beat: int) -> void:
	wegafadence_bars += 1
	#sfx.play()

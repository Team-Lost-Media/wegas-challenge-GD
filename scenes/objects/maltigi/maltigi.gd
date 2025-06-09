extends Sprite3D

## The CharacterBody3D node that Maltigi will target.
@export var player: CharacterBody3D
## The time it takes for Maltigi to enable.
@export var time_to_enable: float = 3
## The time it takes for Maltigi to dash again.
@export var dash_cooldown: float = 3
## The time between Maltigi choosing a target position, and dashing towards it.
@export var dash_delay: float = 0.5
@export var kill = true
@export var death_scene = "res://scenes/menus/gameover/gameover.tscn"
## Must be set to $"maltigi line". Used for drawing the red line from Maltigi to his target position.
@export var line: MeshInstance3D

@onready var start_timer: Timer = $StartTimer
@onready var dash_cooldown_timer: Timer = $StartTimer
@onready var dash_delay_timer: Timer = $DashDelay
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


var enabled = false
var moving = false
var target_position: Vector3
var delta_but_the_one_i_used_in_the_dash_function: float

func _ready() -> void:
	start_timer.start(time_to_enable)

func _process(delta: float) -> void:
	delta_but_the_one_i_used_in_the_dash_function = delta
	
	if enabled == true:
		
		
		
		if dash_cooldown_timer.is_stopped():
			moving = false
			target_position = player.position + player.velocity
			dash_delay_timer.start(dash_delay)
			line.draw(position, target_position)
			#draw the line
			dash_cooldown_timer.start()
		
		if moving == true:
			position = position.move_toward(target_position, 100 * delta_but_the_one_i_used_in_the_dash_function)
		

func _on_start_timer_timeout() -> void:
	enabled = true

func _on_dash_delay_timeout() -> void:
	moving = true
	line.mesh.clear_surfaces()
	#EEEEEAIAIAIARARRHGHGHHARARA
	audio.play()
	print("player: ", player.position, "	target: ", target_position)

func _on_death_area_3d_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		if kill == true:
			get_tree().change_scene_to_file(death_scene)

class_name PlayerCharacter
extends CharacterBody3D

enum CharacterState {
	WALKING = 0,
	SPRINTING = 1,
	CROUCHING = 2
}

# All of the actually important stuff
@onready var head := $head
@onready var InteractRaycast := $head/RayCast3D
@onready var camera := $head/Camera3D
@onready var animator := $AnimationPlayer
var currentState : CharacterState = CharacterState.WALKING
@onready var SPEED = DEFAULT_SPEED # DEFAULT_SPEED doesn't load until _ready(), so we have to use @onready (you could also just move SPEED a bit to the bottom)

# Options
@export var DEFAULT_SPEED := 3
@export var JUMP_VELOCITY := 2.5
@export var mouse_sensitivity := 0.1
@export var SPRINT_SPEED := 3.5
@export var CROUCH_SPEED := 1.5
@export var max_dashes: int = 2
var inputEnabled := true # can the player move?
var aimlookEnabled := true # can the player look around?
var interactionsEnabled := true # can the player interact with Interactibles3D?

# MY variables!!!!!!!!!!!!
var dash_multiplier: float = 1
var dashes_left: int = max_dashes
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var dash_cooldown: Timer = $DashCooldown
@onready var superjump_cooldown: Timer = $SuperJumpCooldown
@onready var dash_cooldown_bar: ProgressBar = $DashCooldownBar
@onready var superjump_cooldown_bar: ProgressBar = $SuperJumpCooldownBar
@onready var just_dashed: Timer = $JustDashed
@onready var just_jumped: Timer = $JustJumped
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var this_timer_only_exists_to_prevent_a_bug_where_if_you_dash_right_after_being_saved_you_clip_through_the_death_area: Timer = $"this timer only exists to prevent a bug where if you dash right after being saved you clip through the death area"
@onready var style_panel: PanelContainer = $PanelContainer #currently only used for the tutorial to show/hide the panel
@onready var damage_effects: Control = $"Damage Effects" #IMOPORTANTANTNNATSNOTN USED FOR THE HTOINGISES TIST TUSES USED FOR THE THINGIES WHEN YO UGET DAMAGED THE THINGS THAT DAMAGE U CALL THIS
@onready var boosted: Timer = $Boosted
@onready var saveable_fall_leniency_timer: Timer = $SaveableFallLeniencyTimer
var coyote: bool
var coyote_disabled: bool
@export var fly: bool = false
@export var disable_collecting_wegadolls: bool = false
@export var fall_saves: int = 0
var saveable_fall = false
@export var testing_grapples = false
@export var show_hp = true
@onready var health_label: Label = $HealthLabel
@onready var health_bar_outline: ColorRect = $HealthBarOutline
@onready var health_bar: ProgressBar = $Health

#region Main control flow 

func _ready():
	$MeshInstance3D.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.player = self
	if show_hp == true:
		health_bar.show()
		health_bar_outline.show()
		health_label.show()
	else:
		health_bar.hide()
		health_bar_outline.hide()
		health_label.hide()
func _physics_process(delta: float) -> void:
	if !inputEnabled:
		return
	
	
	
	if not is_on_floor():
		velocity.y += -55 * delta
		if coyote_timer.is_stopped() and !coyote and !coyote_disabled:
			coyote_timer.start()
			coyote = true
	else:
		coyote_disabled = false
		if saveable_fall_leniency_timer.is_stopped(): saveable_fall = false
	
	if fly:
		if !is_on_floor():
			velocity.y = 0
			if Input.is_action_pressed("Q"):
				velocity.y = 500 * delta
			if Input.is_action_pressed("E"):
				velocity.y = -500 * delta
	
	
	#used for debug
	var enablewega = false
	if enablewega == true:
		if Input.is_action_just_pressed("crouch"):
			if $"../Wega".enabled == true:
				$"../Wega".enabled = false
			else:
				$"../Wega".enabled = true
	
	if Input.is_action_just_pressed("debug"):
		style_panel.hide()
		$DashCooldownBar.hide()
		$SuperJumpCooldownBar.hide()
	
	if Input.is_action_just_pressed("debug"):
		var date = Time.get_date_string_from_system().replace(".","_")
		var time :String = Time.get_time_string_from_system().replace(":","")
		var img = get_viewport().get_texture().get_image()
		img.save_png("res://screenshots/" + date + time + ".png")
	
	if Input.is_action_pressed("jump"):
		if is_on_floor() or coyote:
			if Input.is_action_pressed("superjump") and superjump_cooldown.is_stopped():
				velocity.y = JUMP_VELOCITY * 2.5
				superjump_cooldown.start()
			else:
				velocity.y = JUMP_VELOCITY
				just_jumped.start()
		coyote_disabled = true
	
	if Input.is_action_just_pressed("sprint") and dashes_left > 0 and this_timer_only_exists_to_prevent_a_bug_where_if_you_dash_right_after_being_saved_you_clip_through_the_death_area.is_stopped():
		dash_cooldown.stop()
		just_dashed.start()
		dash_multiplier = 5
		velocity.y = 5
		dashes_left -= 1
		dash_cooldown.start()
	
	if Input.is_action_just_pressed("attack") and testing_grapples == true:
		velocity = -camera.global_basis.z * Vector3(40, 40, 40)
		boosted.start(0.5)
	
	if dash_multiplier > 1:
		dash_multiplier = move_toward(dash_multiplier, 1, 12 * delta)
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if boosted.is_stopped():
		if direction:
			velocity.x = direction.x * SPEED * dash_multiplier
			velocity.z = direction.z * SPEED * dash_multiplier
		else:
			velocity.x = move_toward(velocity.x, 0, 300 * delta)
			velocity.z = move_toward(velocity.z, 0, 300 * delta) 
	else:
		if direction:
			pass
		else:
			velocity.x = move_toward(velocity.x, 0, 30 * delta)
			velocity.z = move_toward(velocity.z, 0, 30 * delta) 
	
	camera.fov = SettingsHandler.fov
	mouse_sensitivity = SettingsHandler.sensitivity
	
	
	# All of the other processing functions go here
	_process_interact()
	_handle_states()
	
	move_and_slide()
	
	#camera bs
	head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
	if Input.is_action_pressed("lookback"):
		head.rotation_degrees.y = 180 #rotation_degrees.y - 180
	else:
		head.rotation_degrees.y = 0

func _on_dash_cooldown_timeout() -> void:
	dashes_left = max_dashes
func _on_coyote_timer_timeout() -> void:
	coyote = false
	coyote_disabled = true

func fade_out_gui(delta: float) -> void:
	style_panel.modulate = style_panel.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
	dash_cooldown_bar.modulate = dash_cooldown_bar.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))
	superjump_cooldown_bar.modulate = superjump_cooldown_bar.modulate.lerp(Color.from_rgba8(255, 255, 255, 0), clamp(1.5 * delta, 0.0, 1.0))


#endregion

#region Processing input

func _process_interact():
	if !interactionsEnabled:
		return
	if not InteractRaycast.is_colliding():
		return
	var collider = InteractRaycast.get_collider()
	

# Handles the mouse 🐁🐁🐁🐁🐁🐁🐁🐁
func _unhandled_input(event : InputEvent):
	if !aimlookEnabled:
		return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouseInput : Vector2
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y
		self.rotation_degrees.y -= mouseInput.x * mouse_sensitivity / 100
		head.rotation_degrees.x -= mouseInput.y * mouse_sensitivity / 100

#endregion

#region Processing Character States

## Handles the input for character state changing. 
func _handle_states():
	change_state(CharacterState.WALKING)

## Handles the state changing itself. This function must be fired only once, and not run every single frame. 
func change_state(state : CharacterState):
	match state:
		CharacterState.CROUCHING:
			animator.play("crouch")
			SPEED = CROUCH_SPEED
		CharacterState.SPRINTING:
			SPEED = SPRINT_SPEED
			animator.play("sprint")
		CharacterState.WALKING:
			if currentState == CharacterState.CROUCHING:
				animator.play_backwards("crouch")
			elif currentState == CharacterState.SPRINTING:
				animator.play_backwards("sprint")
			SPEED = DEFAULT_SPEED
	
	currentState = state

#endregion

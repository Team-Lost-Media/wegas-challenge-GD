extends Control

@onready var rigid_body_2d: RigidBody2D = $RigidBody2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var sfx: AudioStreamPlayer = $sfx

const BODY_MEDIUM_IMPACT_HARD_1 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard1.wav")
const BODY_MEDIUM_IMPACT_HARD_2 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard2.wav")
const BODY_MEDIUM_IMPACT_HARD_3 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard3.wav")
const BODY_MEDIUM_IMPACT_HARD_4 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard4.wav")
const BODY_MEDIUM_IMPACT_HARD_5 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard5.wav")
const BODY_MEDIUM_IMPACT_HARD_6 = preload("res://assets/SFX/ragdoll/body_medium_impact_hard6.wav")

func _ready() -> void:
	static_body_2d.process_mode = Node.PROCESS_MODE_DISABLED

func anim() -> void:
	rigid_body_2d.position.x = randf_range(800, 1200)
	rigid_body_2d.freeze = false
	static_body_2d.process_mode = Node.PROCESS_MODE_INHERIT 


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	var randnum = randi_range(1,6)
	match randnum:
		1:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_1
		2:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_2
		3:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_3
		4:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_4
		5:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_5
		6:
			sfx.stream = BODY_MEDIUM_IMPACT_HARD_6
	sfx.play()

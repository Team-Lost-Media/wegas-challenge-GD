extends Node3D

var punchable: bool = false
var punched: bool = false

@onready var collision: StaticBody3D = $StaticBody3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var sfx: AudioStreamPlayer = $SFX
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var punchable_indicator: Sprite3D = $"punchable indicator"

func _on_punchable_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = true


func _on_punchable_body_exited(body: Node3D) -> void:
	if body is PlayerCharacter:
		punchable = false

func _process(delta: float) -> void:
	punchable_indicator.visible = punchable and !punched
	if Input.is_action_just_pressed("attack") and punchable and !punched:
		collision.queue_free()
		mesh.queue_free()
		sfx.play()
		particles.emitting = true
		punched = true
		Global.style = "+CRATE"
		Global.points += 200
		Global.health += 200/20#handlestylehealthregen
		StyleSFX.play_style_sfx()

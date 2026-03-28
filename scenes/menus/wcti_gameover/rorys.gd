extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var the_bells_toll_for_thee: AudioStreamPlayer = $"the bells toll for thee"

func _ready() -> void:
	texture_rect.position.y = -1500

func anim() -> void:
	audio_stream_player.play()
	sprite.play("default")
	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(texture_rect, "position:y", 0, 0.75).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.25).timeout
	the_bells_toll_for_thee.play()

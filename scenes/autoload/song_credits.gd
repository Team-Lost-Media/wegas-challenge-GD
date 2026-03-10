extends CanvasLayer

@onready var title_label: RichTextLabel = $Control/Title
@onready var author_label: RichTextLabel = $Control/Author
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func show_song_credits(title: String, origin: String, author: String):
	title_label.text = " " + title
	author_label.text = " " + origin + "\n " + author
	
	animation_player.stop()
	animation_player.play("show")
	
	'''
	var tween = create_tween()
	tween.tween_property(texture_rect, "position:x", -100.0, 1.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	var tween2 = create_tween()
	tween2.tween_property(texture_rect, "position:x", -900, 0.8).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)'''

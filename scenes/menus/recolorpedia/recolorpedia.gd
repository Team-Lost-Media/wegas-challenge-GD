extends Control

@onready var go_back_button: TextureButton = $"Selector/Go Back"

@onready var camera: Camera2D = $Camera

@onready var selector: ColorRect = $Selector
@onready var recolorpedia: Control = $Control

@onready var portrait: TextureRect = $Control/Portrait

@onready var name_text: RichTextLabel = $Control/Name
@onready var origin_text: RichTextLabel = $Control/Origin
@onready var behaviour_text: RichTextLabel = $Control/Behaviour/Text
@onready var tips_text: RichTextLabel = $Control/Tips/Text
@onready var info_text: RichTextLabel = $Control/Info/Text
@onready var dev_text: RichTextLabel = $"Control/Dev Commentary/Text"
@onready var style1: TextureRect = $"Control/Style Bonuses/TextureRect"
@onready var style1_title: RichTextLabel = $"Control/Style Bonuses/TextureRect/Title"
@onready var style1_points: RichTextLabel = $"Control/Style Bonuses/TextureRect/Points"
@onready var style1_description: RichTextLabel = $"Control/Style Bonuses/TextureRect/Description"
@onready var style2: TextureRect = $"Control/Style Bonuses/TextureRect2"
@onready var style2_title: RichTextLabel = $"Control/Style Bonuses/TextureRect2/Title"
@onready var style2_points: RichTextLabel = $"Control/Style Bonuses/TextureRect2/Points"
@onready var style2_description: RichTextLabel = $"Control/Style Bonuses/TextureRect2/Description"
@onready var style3: TextureRect = $"Control/Style Bonuses/TextureRect3"
@onready var style3_title: RichTextLabel = $"Control/Style Bonuses/TextureRect3/Title"
@onready var style3_points: RichTextLabel = $"Control/Style Bonuses/TextureRect3/Points"
@onready var style3_description: RichTextLabel = $"Control/Style Bonuses/TextureRect3/Description"
@onready var style4: TextureRect = $"Control/Style Bonuses/TextureRect4"
@onready var style4_title: RichTextLabel = $"Control/Style Bonuses/TextureRect4/Title"
@onready var style4_points: RichTextLabel = $"Control/Style Bonuses/TextureRect4/Points"
@onready var style4_description: RichTextLabel = $"Control/Style Bonuses/TextureRect4/Description"
@onready var style5: TextureRect = $"Control/Style Bonuses/TextureRect5"
@onready var style5_title: RichTextLabel = $"Control/Style Bonuses/TextureRect5/Title"
@onready var style5_points: RichTextLabel = $"Control/Style Bonuses/TextureRect5/Points"
@onready var style5_description: RichTextLabel = $"Control/Style Bonuses/TextureRect5/Description"
@onready var style6: TextureRect = $"Control/Style Bonuses/TextureRect6"
@onready var style6_title: RichTextLabel = $"Control/Style Bonuses/TextureRect6/Title"
@onready var style6_points: RichTextLabel = $"Control/Style Bonuses/TextureRect6/Points"
@onready var style6_description: RichTextLabel = $"Control/Style Bonuses/TextureRect6/Description"

var char_to_entry_path_dict = {
	"Wega" = "res://scenes/menus/recolorpedia/text/wega.txt",
	"Rorys" = "res://scenes/menus/recolorpedia/text/rorys.txt",
	"Maltigi" = "res://scenes/menus/recolorpedia/text/maltigi.txt",
	"Ultra Irios" = 4,
	"Super John" = 5,
}

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/mainMenu.tscn")

func _process(delta: float) -> void:
	for child in selector.get_children():
		if child is TextureButton and child != go_back_button: #the second if condition is to prevent the "GO BACK" button from doing this
			if child.is_hovered():
				var child_label = child.get_child(0)
				set_recolorpedia_to_entry_file(char_to_entry_path_dict.get(child_label.text))
				change_portrait(child_label.text)
				var tween = create_tween()
				tween.tween_property(child, "position:x", 0, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			else:
				var tween = create_tween()
				tween.tween_property(child, "position:x", -90, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	#print("potato".substr("potato".find("o"), len("potato") - len("potato") + 4))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !Input.is_action_pressed("superjump"):
			if event.button_index == 4:
				recolorpedia.position.y += 25
			if event.button_index == 5:
				recolorpedia.position.y -= 25
		'''else:
			if event.button_index == 4:
				camera.zoom += Vector2(0.2, 0.2)
				camera.offset = get_global_mouse_position()
			if event.button_index == 5:
				camera.zoom -= Vector2(0.2, 0.2)'''
	
	if camera.zoom <= Vector2(1, 1):
		camera.zoom = Vector2(1, 1)
		camera.offset = Vector2(0, 0)
	recolorpedia.position.y = clampf(recolorpedia.position.y, -1000, 0)

func _ready() -> void:
	set_recolorpedia_to_entry_file("res://scenes/menus/recolorpedia/text/wega.txt")

func set_recolorpedia_to_entry_file(entry_filepath: String) -> void:
	var file = get_file_as_string(entry_filepath)
	var entry_text = file.split("\n")
	name_text.text = entry_text.get(0).replace("[br]", "\n")
	origin_text.text = entry_text.get(1).replace("[br]", "\n")
	behaviour_text.text = entry_text.get(2).replace("[br]", "\n")
	tips_text.text = entry_text.get(3).replace("[br]", "\n")
	info_text.text = entry_text.get(4).replace("[br]", "\n")
	dev_text.text = entry_text.get(5).replace("[br]", "\n")
	style1_title.text = entry_text.get(6).replace("[br]", "\n")
	style1_points.text = "[i]ADDS:[/i]\n" + entry_text.get(7) + "\n[i]points[/i]"
	style1_description.text = entry_text.get(8).replace("[br]", "\n")
	style2_title.text = entry_text.get(9).replace("[br]", "\n")
	style2_points.text = "[i]ADDS:[/i]\n" + entry_text.get(10) + "\n[i]points[/i]"
	style2_description.text = entry_text.get(11).replace("[br]", "\n")
	style3_title.text = entry_text.get(12).replace("[br]", "\n")
	style3_points.text = "[i]ADDS:[/i]\n" + entry_text.get(13) + "\n[i]points[/i]"
	style3_description.text = entry_text.get(14).replace("[br]", "\n")
	style4_title.text = entry_text.get(15).replace("[br]", "\n")
	style4_points.text = "[i]ADDS:[/i]\n" + entry_text.get(16) + "\n[i]points[/i]"
	style4_description.text = entry_text.get(17).replace("[br]", "\n")
	style5_title.text = entry_text.get(18).replace("[br]", "\n")
	style5_points.text = "[i]ADDS:[/i]\n" + entry_text.get(19) + "\n[i]points[/i]"
	style5_description.text = entry_text.get(20).replace("[br]", "\n")
	style6_title.text = entry_text.get(21).replace("[br]", "\n")
	style6_points.text = "[i]ADDS:[/i]\n" + entry_text.get(22) + "\n[i]points[/i]"
	style6_description.text = entry_text.get(23).replace("[br]", "\n")
	
	
	#region hiding style bonuses if left empty
	if entry_text.get(6) == "///":
		style1.hide()
	else:
		style1.show()
	if entry_text.get(9) == "///":
		style2.hide()
	else:
		style2.show()
	if entry_text.get(12) == "///":
		style3.hide()
	else:
		style3.show()
	if entry_text.get(15) == "///":
		style4.hide()
	else:
		style4.show()
	if entry_text.get(18) == "///":
		style5.hide()
	else:
		style5.show()
	if entry_text.get(21) == "///":
		style6.hide()
	else:
		style6.show()

func get_file_as_string(file_to_load: String):
	var file = FileAccess.open(file_to_load, FileAccess.READ)
	var content = file.get_as_text()
	return content

func change_portrait(to_what: String) -> void:
	for child in portrait.get_children():
		child.hide()
		if to_what == child.name:
			child.show()

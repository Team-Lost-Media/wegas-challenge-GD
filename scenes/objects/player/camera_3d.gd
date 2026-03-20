extends Camera3D

@onready var green_lawson_playermodel: Node3D = $"../../GreenLawsonPlayermodel"
@onready var arms_player_model: Node3D = $"ArmsPlayerModel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match Global.camera_style:
		0:
			position = Vector3(0,0,0)
			green_lawson_playermodel.hide()
			arms_player_model.show()
		1:
			position = Vector3(0,0.4,1.5)
			green_lawson_playermodel.show()
			arms_player_model.hide()

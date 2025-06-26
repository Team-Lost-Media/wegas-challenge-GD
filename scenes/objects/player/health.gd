extends ProgressBar

@export var health_label_text_color: GradientTexture1D
@onready var health_label: Label = $"../HealthLabel"

func _ready() -> void:
	Global.health = 100

func _process(delta: float) -> void:
	value = Global.health
	health_label.text = "HP: " + str(snappedf(Global.health, 0.1))
	health_label.label_settings.font_color = health_label_text_color.gradient.sample(Global.health / 100)
	#print(health_label_text_color.gradient.sample(Global.health / 100))

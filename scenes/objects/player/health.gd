extends ProgressBar

@export var health_label_text_color: GradientTexture1D
@onready var health_label: Label = $"../HealthLabel"

@export var health2: bool = false
@export var health2_curve: Curve

func _process(delta: float) -> void:
	value = Global.health
	if not health2:
		health_label.text = "HP: " + str(snappedf(Global.health, 0.1))
		health_label.label_settings.font_color = health_label_text_color.gradient.sample(Global.health / 200)
	else:
		$Label.scale.x = health2_curve.sample(Global.health)
	#print(health_label_text_color.gradient.sample(Global.health / 100))

#0 3.713

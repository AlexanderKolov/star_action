extends CanvasLayer

@onready var hp_bar = $Node2D/hp_bar
@onready var shild_bar = $Node2D/shild_bar

func _ready():
	update_ui(100, 100)

func update_ui(hp, shild):
	hp_bar.text = str(hp)
	shild_bar.text = str(shild)

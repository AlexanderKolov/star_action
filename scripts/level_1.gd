extends Node2D
@export var world_bounds: Rect2 = Rect2(-2000, -2000, 4000, 4000)


func _ready():
	var player = $player
	if player:
		player.world_bounds = world_bounds
	var _center = Vector2.ZERO

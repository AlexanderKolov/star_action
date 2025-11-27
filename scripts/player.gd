extends CharacterBody2D
#===================КОНСТАНТЫ===================
@export var speed: float = 100.0
@export var hp: int = 100
@export var shild:int = 100
var world_bounds: Rect2
var is_dead: bool = false # ←  ФЛАГ СМЕРТИ


@onready var ui = $"../CanvasLayer"
#===================МЕХАНИКИ===================
func _ready():
	add_to_group('player')
	
#===================ОБНОВЛЕНИЕ УРОНА (КОНВА)===================
func update_ui():
	if ui:
		ui.update_ui(hp, shild)

#===================ПОЛУЧЕНИЕ УРОНА===================
func take_damage(damage: int):
	if is_dead: # ← ЗАЩИТА ОТ УРОНА ПОСЛЕ СМЕРТИ
		return
	if shild > 0:
		shild -= damage
		if shild < 0:
			shild =  0
	else:
		hp -= damage
		if hp < 0:
			hp = 0
	update_ui()
	dei()
#===================СМЕРТЬ===================
func dei():
	if hp <= 0 and not is_dead:
		is_dead = true
		print("💀 Игрок умер!")
		await get_tree().create_timer(0.5).timeout
		game_over()
		queue_free()
		
#===================КОНЕЦ ИГРЫ===================
func game_over():
	if is_dead == true:
		get_tree().change_scene_to_file("res://scene/game_over.tscn")
#===================ДВИЖЕНИЕ===================
func _physics_process(_delta):
	if is_dead: # ← НЕ ДВИГАЕМ МЕРТВОГО
		return
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_raw_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_raw_strength("move_up")
	velocity = input.normalized() * speed 
#ПОВОРОТ
	if input.length() > 0:
		var target_angle = input.angle()
		rotation = lerp_angle(rotation, target_angle, 0.089)

	move_and_slide()
	if world_bounds:
		position = position.clamp(world_bounds.position, world_bounds.end)

extends CharacterBody2D


@export var speed: float = 100.0
@export var hp: int = 100
@export var shild:int = 100
@export var rotation_speed: float =  5.0 # Скорость поворота спрайта
@onready var direction_marker = $"look at"
@onready var sprite = $EnemyBlack2
var player: Node2D 
var is_dead: bool = false
var should_follow = false
func _ready() -> void:
	player = $"../player"
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
	dei()
#===================СМЕРЬ===================
func dei():
	if hp <= 0 and not is_dead:
		is_dead = true
		print("💀 Враг умер!")
		await get_tree().create_timer(0.5).timeout
		queue_free()
#===================ПРЕСЛЕДОВАНИЕ===================
func follow():
	if not is_instance_valid(player):
		stop_follow()
		return
	
	##===================ПОВОРОТ ПО МАРКЕРУ===================
	direction_marker.look_at(player.global_position)
	var target_rotation = direction_marker.rotation - PI/2
	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, rotation_speed * get_physics_process_delta_time())
	velocity = direction_marker.transform.x * speed

#===================ПРЕКРАЩЕНИЕ ПРЕСЛЕДОВАНИЯ===================
func stop_follow():

	velocity = Vector2.ZERO
	print("👻 Игрок вышел из зоны! Прекращаю преследование.")
#===================PHYSICAL PROCESS===================
func _physics_process(_delta: float) -> void:
	if should_follow and player:
		follow()
	move_and_slide()
#===================ПОПАДАНИЕ В ЗОНУ ПРЕСЛЕДОВАНИЯ===================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		player = body
		should_follow = true
		print("🎯 Игрок обнаружен! Начинаю преследование.")
#===================ВЫХОД ИЗ ЗОНЫ ПРЕСЛЕДОВАНИЯ===================
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		should_follow = false
		stop_follow()
		print("👻 Игрок потерян!.")
	

#===================ПОПАДАНИЕ В ЗОНУ ПРЕСЛЕДОВАНИЯ===================
func _on_follow_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		player = body
		should_follow = true
		print("🎯 Игрок обнаружен! Начинаю преследование.")

#===================ВЫХОД ИЗ ЗОНЫ ПРЕСЛЕДОВАНИЯ===================
func _on_follow_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		should_follow = false
		stop_follow()
		print("👻 Игрок потерян!.")

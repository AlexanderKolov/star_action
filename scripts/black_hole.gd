extends Area2D
################ КОНСТАНТЫ ###################
@export var damage_per_second = 10
@export var pull_force: float = 200.0
@export var damage_time: float = 1.0
var target_in_zone = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = damage_time
	$Timer.timeout.connect(_on_timer_timeout)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		target_in_zone.append(body)
		$Timer.start()



#===============ИГРОК ВЫШЕЛ ИЗ ЗОНЫ=============               
func _on_body_exited(body: Node2D) -> void:
	if body.has_method('take_damage'):
		target_in_zone.erase(body)
#		
		if target_in_zone.size() == 0:
			$Timer.stop()
			

func _on_timer_timeout():
	for target in  target_in_zone:
		if target.has_method('take_damage'):
			target.take_damage(damage_per_second)
	

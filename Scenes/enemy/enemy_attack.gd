extends State

@export var enemy: Node2D
@export var search_component: Node2D
@export var weapon_component: Node2D

var target_pos: Vector2

func _physics_process(_delta: float) -> void:
	if search_component.can_see_player():
		target_pos = search_component.player_ref.global_position
		enemy.update_direction(target_pos)
		enemy.move()
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)
	else:
		transitioned.emit(self, "EnemyWander")

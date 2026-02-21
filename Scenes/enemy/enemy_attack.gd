extends State

@export var enemy: Node2D
@export var search_component: Node2D
@export var weapon_component: Node2D

var target_pos: Vector2
var min_dist := 150

func enter():
	set_nav_layer()

func set_nav_layer():
	enemy.navigation_agent_2d.set_navigation_layer_value(1,true)
	enemy.navigation_agent_2d.set_navigation_layer_value(2,false)

func physics_update(_delta: float) -> void:
	if search_component.can_see_player():
		target_pos = search_component.player_ref.global_position
		if enemy.global_position.distance_to(target_pos) > min_dist:
			enemy.set_nav_to_target(target_pos)
			enemy.update_nav()
		else:
			enemy.stop()
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)
	else:
		transitioned.emit(self, "EnemyWander")

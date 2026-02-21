extends State

@export var enemy: Node2D
@export var nav_agent: NavigationAgent2D
@export var search_component: Node2D

var patrol_points: Array
var patrol_target: Vector2

func _ready() -> void:
	get_patrol_points()

func get_patrol_points():
	patrol_points = enemy.map.get_patrol_points()

func enter():
	get_next_patrol_point()
	set_nav_layer()

func set_nav_layer():
	nav_agent.set_navigation_layer_value(2, true)
	nav_agent.set_navigation_layer_value(1, false)

func get_next_patrol_point():
	patrol_target = patrol_points.pick_random()

func physics_update(_delta: float) -> void:
	enemy.set_nav_to_target(patrol_target)
	enemy.update_nav()
	if enemy.navigation_agent_2d.is_target_reached():
		enemy.set_cur_pos()
		get_next_patrol_point()
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyAttack")

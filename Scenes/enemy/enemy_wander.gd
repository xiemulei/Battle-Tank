extends State

@export var enemy: Node2D
@export var distance: float = 200
@export var search_component: Node2D
@onready var timer: Timer = $Timer

var target_pos: Vector2
var noise: float = 50
var end_wander: bool

func _ready() -> void:
	timer.timeout.connect(on_time_out)

func enter():
	set_nav_layer()
	end_wander = false
	find_next_point()
	timer.start(5)

func set_nav_layer():
	enemy.navigation_agent_2d.set_navigation_layer_value(1, true)
	enemy.navigation_agent_2d.set_navigation_layer_value(2, false)

func physics_update(_delta: float):
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyAttack")
	else:
		if not end_wander:
			enemy.update_direction(target_pos)
			enemy.update_nav()
			if enemy.navigation_agent_2d.is_target_reached():
				find_next_point()
		else:
			target_pos = enemy.cur_pos
			enemy.set_nav_to_target(target_pos)
			enemy.update_nav()
			if enemy.navigation_agent_2d.is_target_reached():
				transitioned.emit(self, "EnemyPatrol")

func find_next_point():
	var random_x = randf_range(-noise, noise)
	var random_y = randf_range(-noise, noise)
	var random_vec = Vector2(random_x, random_y)
	var pos = distance * enemy.transform.x + random_vec
	target_pos = enemy.global_position + pos

func on_time_out():
	end_wander = true

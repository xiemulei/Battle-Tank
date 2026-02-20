extends State

@export var enemy: Node2D
@export var search_component: Node2D

var points_array: Array
var target_pos: Vector2
var target_index: int = 0

func _ready() -> void:
	get_points()
	
func enter():
	find_next_point()

func get_points():
	for point: Marker2D in enemy.points.get_children():
		points_array.append(point.global_position)

func find_next_point():
	if target_index >= points_array.size():
		target_index = 0
	target_pos = points_array[target_index]
	target_index += 1

func physics_update(_delta: float) -> void:
	enemy.update_direction(target_pos)
	enemy.move()
	if near_point():
		find_next_point()
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyAttack")

func near_point():
	if enemy.global_position.distance_to(target_pos) < 5:
		return true
	else:
		return false

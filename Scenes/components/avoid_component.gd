class_name AvoidComponent
extends ShapeCast2D

@export var force: float = 2

func obstacks_detected():
	return is_colliding()

func get_new_direction():
	if obstacks_detected():
		var normal_vec = get_collision_normal(0)
		var direction = owner.transform.x + normal_vec * force
		return direction

func _process(delta: float) -> void:
	get_new_direction()

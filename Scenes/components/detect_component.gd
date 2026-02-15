class_name DetectComponent
extends Area2D

func get_player_pos():
	if has_overlapping_areas():
		var targets = get_overlapping_areas()
		if not targets.is_empty():
			return targets[0].global_position

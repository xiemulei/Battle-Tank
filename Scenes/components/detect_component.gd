class_name DetectComponent
extends Area2D

var player_pos = null

func get_player_pos():
	if has_overlapping_areas():
		var targets = get_overlapping_areas()
		if not targets.is_empty():
			return targets[0].global_position

func find_player() -> bool:
	player_pos = get_player_pos()
	if player_pos:
		return true
	else:
		return false

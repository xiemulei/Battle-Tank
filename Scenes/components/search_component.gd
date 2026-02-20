class_name SearchComponent
extends RayCast2D

var player_ref: Player

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if player_ref:
		look_at(player_ref.global_position)

func get_player_angle():
	var angle = transform.get_rotation()
	return abs(angle)

func player_detected():
	var obj = get_collider()
	if obj:
		return obj.is_in_group("Player")
	return false

func can_see_player():
	if get_player_angle() < PI / 2 and player_detected():
		return true
	else:
		return false

extends Node

signal enemy_killed(pos: Vector2)
signal update_health_ui(health: int)
signal player_killed
signal player_win

var score: int = 0
var enemy_size: int = 3

func _ready() -> void:
	enemy_killed.connect(on_enemy_killed)
	
func on_enemy_killed(pos):
	score += 1
	if score == enemy_size:
		player_win.emit()

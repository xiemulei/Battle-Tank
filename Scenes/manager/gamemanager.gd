extends Node

signal bullet_hit(pos: Vector2)
signal entity_died(pos: Vector2, groups: Array)
signal player_killed
signal player_win
signal score_update
signal update_health_ui(health: float)
signal update_score_ui(score: int, total: int)
signal level_start

@onready var game_scene: PackedScene = preload("res://Scenes/game/game.tscn")
@onready var menu_scene: PackedScene = preload("res://Scenes/UI/menu.tscn")

var current_level: int = 1
var score: int = 0
var total_enemy_size: int

func _ready() -> void:
	score_update.connect(on_score_update)
	player_killed.connect(on_player_killed)

func set_total_enemy_size(value: int):
	total_enemy_size = value

func on_score_update():
	score += 1
	update_score_ui.emit(score, total_enemy_size)

func on_player_killed():
	pass

func restart():
	score = 0
	get_tree().reload_current_scene()

func reset_score():
	score = 0

func next_level():
	current_level += 1

func to_menu():
	get_tree().change_scene_to_packed(menu_scene)

func to_game():
	get_tree().change_scene_to_packed(game_scene)

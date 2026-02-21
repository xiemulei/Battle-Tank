extends Node

signal wave_died

@export var enemy_tank_scene: PackedScene
@export var enemy_mis_scene: PackedScene
@export var enemy_tower_scene: PackedScene
@export var map: Node2D

var died_tank: int
var died_enemy: int
var total_enemy_size: int
var tower_points: Array[Vector2i]

@export var wave_number: int = 3
@export var enemy_in_wave: int = 8
@export var enemy_tank_rat: float = 0.5
@export var enemy_tower_num: int = 10
@export var enemy_spawn_time: int = 2
@export var enemies_holder: Node2D

@onready var paths: Array

func _ready() -> void:
	tower_points = map.get_tower_points(enemy_tower_num)
	Gamemanager.entity_died.connect(on_entity_died)
	spawn_tower()
	check_enemy_size()
	spawn_waves()

func on_entity_died(_pos: Vector2, groups: Array):
	check_wave_end(groups)
	check_killed_enemy(groups)

func spawn_tower():
	for point in tower_points:
		var enemy_tower = enemy_tower_scene.instantiate()
		enemies_holder.add_child(enemy_tower)
		enemy_tower.global_position = point

func check_wave_end(groups: Array):
	if "EnemyTank" in groups:
		died_tank += 1
		if died_tank == enemy_in_wave:
			wave_died.emit()

func check_killed_enemy(groups: Array):
	if "Enemy" in groups:
		died_enemy += 1
		Gamemanager.score_update.emit()
		if died_enemy == total_enemy_size:
			Gamemanager.player_win.emit()

func check_enemy_size():
	for enemy in enemies_holder.get_children():
		if "EnemyTower" in enemy.get_groups():
			total_enemy_size += 1
	total_enemy_size += wave_number * enemy_in_wave
	Gamemanager.set_total_enemy_size(total_enemy_size)

func spawn_waves():
	for i in wave_number:
		spawn_wave()
		await wave_died

func spawn_wave():
	died_tank = 0
	for i in enemy_in_wave:
		call_deferred("spawn_enemy")
		await get_tree().create_timer(enemy_spawn_time).timeout

func spawn_enemy():
	var enemy: Node2D
	if randf_range(0, 1) < enemy_tank_rat:
		enemy = enemy_tank_scene.instantiate()
	else:
		enemy = enemy_mis_scene.instantiate()
	enemy.speed = randi_range(100, 150)
	enemy.global_position = map.enemy_start_pos
	enemy.map = map
	enemies_holder.add_child(enemy)

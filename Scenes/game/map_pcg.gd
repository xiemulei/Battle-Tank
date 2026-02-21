extends Node2D

@onready var grass: TileMapLayer = $Grass
@onready var road: TileMapLayer = $Road
@onready var border: TileMapLayer = $Border
@onready var items: TileMapLayer = $Items
@onready var tree: TileMapLayer = $Tree

@export var map_size = Vector2i(45, 22)
@export var points: Node2D
@export var path_point_count: int = 5

const grass_id: int = 0
const nav_grass_atlas := Vector2i(0, 0)
const border_tree_id: int = 5
const border_tree_atlas := Vector2i(0, 0)
const nonav_grass_atlas := Vector2i(0, 1)
const brown_tree_id :int = 6
const brown_tree_atlas = Vector2i(0,0)
const stone_id :int = 10
const stone_atlas = [Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)]

var cell_size := Vector2(64, 64)
var enemy_start: Vector2i
var enemy_start_pos: Vector2
var enemy_safe_area: Array[Vector2i]
var player_start: Vector2i
var player_start_pos: Vector2
var player_safe_area: Array[Vector2i]
var path_top_left: Vector2i
var path_bottom_right: Vector2i
var path_cell: Array[Vector2i]
var free_cell: Array[Vector2i]

var astargrid := AStarGrid2D.new()
var path_generator := PathGenerator.new()

func _ready() -> void:
	set_map_parameter()
	setup_grass()
	setup_safe_area()
	setup_border()
	setup_astargrid()
	setup_pathgenerator()
	get_random_path()
	setup_free_cell()
	setup_stones()
	setup_trees()

func setup_astargrid():
	astargrid.region = grass.get_used_rect()
	astargrid.cell_size = cell_size
	astargrid.offset = cell_size / 2
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()

func setup_pathgenerator():
	path_generator.setup(path_top_left, path_bottom_right, enemy_start, player_start, path_point_count)

func set_map_parameter():
	enemy_start_pos = points.get_node("EnemyStart").global_position
	enemy_start = grass.local_to_map(enemy_start_pos)
	player_start_pos = points.get_node("PlayerStart").global_position
	player_start = grass.local_to_map(player_start_pos)
	path_top_left = grass.local_to_map(points.get_node("TopLeft").global_position)
	path_bottom_right = grass.local_to_map(points.get_node("BottomRight").global_position)

func setup_grass():
	grass.clear()
	for cell_x in range(map_size.x):
		for cell_y in range(map_size.y):
			grass.set_cell(Vector2i(cell_x, cell_y), grass_id, nav_grass_atlas)

func setup_safe_area():
	var enemy_start_surround = grass.get_surrounding_cells(enemy_start)
	enemy_safe_area.append(enemy_start)
	enemy_safe_area.append_array(enemy_safe_area)
	for cell in enemy_start_surround:
		enemy_safe_area.append_array(grass.get_surrounding_cells(cell))
	var player_start_surround = grass.get_surrounding_cells(player_start)
	player_safe_area.append(player_start)
	player_safe_area.append_array(player_start_surround)
	for cell in player_start_surround:
		player_safe_area.append_array(grass.get_surrounding_cells(cell))

func setup_border():
	var border_top_left = Vector2i.ZERO - Vector2i.ONE
	var border_bottom_right = map_size
	for cell_x in range(border_top_left.x, border_bottom_right.x + 1):
		grass.set_cell(Vector2i(cell_x, border_top_left.y), grass_id, nonav_grass_atlas)
		grass.set_cell(Vector2i(cell_x, border_bottom_right.y), grass_id, nonav_grass_atlas)
		border.set_cell(Vector2i(cell_x, border_top_left.y), border_tree_id, border_tree_atlas)
		border.set_cell(Vector2i(cell_x, border_bottom_right.y), border_tree_id, border_tree_atlas)
	for cell_y in range(border_top_left.y, border_bottom_right.y + 1):
		grass.set_cell(Vector2i(border_top_left.x, cell_y), grass_id, nonav_grass_atlas)
		grass.set_cell(Vector2i(border_bottom_right.x, cell_y), grass_id, nonav_grass_atlas)
		border.set_cell(Vector2i(border_top_left.x, cell_y), border_tree_id, border_tree_atlas)
		border.set_cell(Vector2i(border_bottom_right.x, cell_y), border_tree_id, border_tree_atlas)

func get_random_path():
	var path_points: Array[Vector2i] = path_generator.generate_random_points()
	var path_start = enemy_start
	for point in path_points:
		path_cell.append_array(astargrid.get_id_path(path_start, point))
		path_start = point
	var path_end = player_start
	path_cell.append_array(astargrid.get_id_path(path_start, path_end))
	road.set_cells_terrain_connect(path_cell, 0, 0)

func setup_free_cell():
	var grass_cell = grass.get_used_cells_by_id(grass_id, nav_grass_atlas)
	var road_cell = road.get_used_cells()
	
	for cell in grass_cell:
		if (cell not in road_cell and
			cell not in enemy_safe_area and
			cell not in player_safe_area):
			free_cell.append(cell)

func set_item(tile: TileMapLayer, prob: float, item_id: int, item_atlas: Array, cannot_nav: bool):
	var cell = free_cell.pick_random()
	if cannot_nav:
		grass.set_cell(cell, grass_id, nonav_grass_atlas)
	tile.set_cell(cell, item_id, item_atlas.pick_random())
	free_cell.erase(cell)
	var near_cells = items.get_surrounding_cells(cell)
	for near_cell in near_cells:
		if randf_range(0, 1) < prob and near_cell in free_cell:
			if cannot_nav:
				grass.set_cell(near_cell, grass_id, nonav_grass_atlas)
			tile.set_cell(near_cell, item_id, item_atlas.pick_random())
			free_cell.erase(cell)

func setup_stones(item_num: int = 8):
	for i in range(item_num):
		set_item(items, 0.5, stone_id, stone_atlas, true)

func setup_trees(item_num: int = 5):
	for i in range(item_num):
		set_item(tree, 0.5, brown_tree_id, [brown_tree_atlas], false)

func get_patrol_points(patrol_num: int = 5) -> Array[Vector2i]:
	var patrol_points: Array[Vector2i]
	var road_cells = road.get_used_cells()
	for i in range(patrol_num):
		var pick_point = road_cells.pick_random()
		road_cells.erase(pick_point)
		patrol_points.append(pick_point)
	return patrol_points

func get_tower_points(tower_num: int = 8, max_try: int = 100):
	var road_cell = road.get_used_cells()
	var tower_points: Array[Vector2i]
	var try_count: int = 0
	for i in range(tower_num):
		while try_count < max_try:
			var rand_point = road_cell.pick_random()
			var surround_cell = grass.get_surrounding_cells(rand_point)
			var tower_point = get_surround_free_cell(surround_cell)
			if tower_point:
				tower_points.append(tower_point)
				break
			else:
				try_count += 1
	return tower_points

func get_surround_free_cell(surround_cell: Array[Vector2i]):
	for cell in surround_cell:
		if cell in free_cell:
			grass.set_cell(cell, grass_id, nonav_grass_atlas)
			var point = grass.map_to_local(cell)
			if point.distance_to(player_start_pos) > 400:
				return point
	return null

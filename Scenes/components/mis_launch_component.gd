extends Node2D

var can_shoot: bool = true
var min_cool_down: float = 0.2

@export var cool_down: float = 0.5
@export var missile_scene: PackedScene
@onready var marker_1: Marker2D = $Sprite2D/Marker2D1
@onready var marker_2: Marker2D = $Sprite2D/Marker2D2
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var timer: Timer = $Timer
@onready var launch_pos = [marker_1, marker_2]

func _ready() -> void:
	timer.timeout.connect(on_time_out)

func target(target_pos: Vector2):
	look_at(target_pos)

func shoot(target_pos: Vector2):
	if can_shoot:
		timer.start(cool_down)
		shoot_sound.play()
		can_shoot = false
		var missile: EnemyMissile = missile_scene.instantiate()
		missile.global_position = launch_pos.pick_random().global_position
		missile.look_at(target_pos)
		missile.top_level = true
		add_child(missile)

func on_time_out():
	can_shoot = true

func upgrade(value):
	cool_down = max(min_cool_down, cool_down - value)

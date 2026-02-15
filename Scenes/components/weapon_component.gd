class_name WeaponComponent
extends Node2D

var can_shoot: bool = true
var min_cool_down: float = 0.2

@export var cool_down: float = 0.5
@export var bullet_scene: PackedScene
@onready var marker_2d: Marker2D = $Gun/Marker2D
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	timer.timeout.connect(on_time_out)
	
func target(target_pos: Vector2):
	look_at(target_pos)

func on_time_out():
	can_shoot = true
	
func shoot(target_pos: Vector2):
	if can_shoot:
		timer.start(cool_down)
		if cool_down < 0.5:
			animation_player.speed_scale = 0.5 / cool_down  # 冷却时间缩短，加快动画播放速度
		animation_player.play("shoot")
		can_shoot = false
		var bullet = bullet_scene.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.look_at(target_pos)
		bullet.top_level = true
		add_child(bullet)

# 武器升级，缩短冷却时间
func upgrade(value):
	cool_down = max(min_cool_down, cool_down - value)

class_name EnemyMissile
extends Node2D

@export var speed: float = 300
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent
@onready var detect_component: DetectComponent = $DetectComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	hit_box_component.hit.connect(on_hit)
	hurt_box_component.get_damage.connect(health_component.get_damage)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)
	health_component.died.connect(on_died)

func _process(delta: float) -> void:
	if detect_component.can_see_player():
		update_direction(detect_component.player_ref.global_position, delta)
	move_forward(delta)

func update_direction(target_pos: Vector2, delta: float):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)

func move_forward(delta: float):
	position += transform.x * speed * delta

func on_hit():
	Gamemanager.bullet_hit.emit(global_position)
	queue_free()

func on_screen_exited():
	queue_free()

func on_died():
	Gamemanager.entity_died.emit(global_position, get_groups())
	queue_free()

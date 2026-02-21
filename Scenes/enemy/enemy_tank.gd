class_name EnemyTank
extends CharacterBody2D

@export var points: Node2D
@export var speed: float = 100
@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var trail_component: Node2D = $TrailComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var search_component: SearchComponent = $SearchComponent
@onready var avoid_component: AvoidComponent = $AvoidComponent
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var cur_pos: Vector2

func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)
	set_cur_pos()
	navigation_agent_2d.velocity_computed.connect(on_velocity_computed)

func set_cur_pos():
	cur_pos = global_position

func _physics_process(_delta: float) -> void:
	trail_component.start()

func on_died():
	Gamemanager.entity_died.emit(global_position, get_groups())
	queue_free()

func on_get_damage(_damage: float):
	animation_player.play("flash")

func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	var delta = get_physics_process_delta_time()
	rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)

func set_nav_to_target(target: Vector2):
	navigation_agent_2d.target_position = target

func on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity

func update_nav():
	if not navigation_agent_2d.is_navigation_finished():
		var next_pos = navigation_agent_2d.get_next_path_position()
		update_direction(next_pos)
		var new_velocity = transform.x * speed
		if navigation_agent_2d.avoidance_enabled:
			navigation_agent_2d.set_velocity_forced(new_velocity)
		else:
			velocity = new_velocity
		move_and_slide()

func stop():
	if navigation_agent_2d.avoidance_enabled	:
		navigation_agent_2d.set_velocity_forced(Vector2.ZERO)
	else:
		velocity = Vector2.ZERO

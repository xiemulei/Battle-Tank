class_name Player
extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 0
var can_shake := false

@export var max_speed: float = 300
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var trail_component: Node2D = $TrailComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	hurt_box_component.get_damage.connect(on_get_damage)
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(on_died)
	Gamemanager.player_win.connect(on_player_win)

func on_get_damage(_value):
	animation_player.play("flash")
	can_shake = true
	timer.start()

func on_time_out():
	can_shake = false

func on_health_changed(health: float):
	Gamemanager.update_health_ui.emit(health)

func on_died():
	Gamemanager.entity_died.emit(global_position, get_groups())
	Gamemanager.player_killed.emit()
	set_physics_process(false)
	hide()
	hurt_box_component.set_deferred("monitorable", false)

func upgrade_weapon():
	weapon_component.upgrade(0.1)

func upgrade_health():
	health_component.upgrade(1)

func on_player_win():
	set_physics_process(false)

func _process(_delta: float) -> void:
	# 武器始终朝向鼠标位置
	var target_pos = get_global_mouse_position()
	weapon_component.target(target_pos)
	# 检测射击输入
	if Input.is_action_just_pressed("shoot"):
		weapon_component.shoot(target_pos)

func _physics_process(delta: float) -> void:
	move(delta)
	if can_shake:
		shake()
	
func move(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
		trail_component.start()
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
		trail_component.stop()
	
	velocity = transform.x * speed
	move_and_slide()

func shake():
	camera_2d.offset = Vector2(randf_range(-3, 3), randf_range(-3, 3))

func check_border():
	var size = get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, size)

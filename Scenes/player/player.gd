class_name Player
extends Area2D

var direction: Vector2 = Vector2.ZERO
var target_pos: Vector2
var speed: float = 0
var health: int = 10

@export var max_speed: float = 300
@export var bullet_scene: PackedScene
@onready var marker_2d: Marker2D = $Gun/Marker2D
@onready var gun: Sprite2D = $Gun
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

func reduce_health():
	if health > 0:
		health -= 1
		Gamemanager.update_health_ui.emit(health)
	if health <= 0:
		Gamemanager.player_killed.emit()
	
func _ready() -> void:
	Gamemanager.player_killed.connect(on_player_killed)

func on_player_killed():
	set_process(false)

func _process(delta: float) -> void:
	move(delta)
	check_border()
	target()
	shoot()
	
func move(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
	position += transform.x * speed * delta

func check_border():
	var size = get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, size)

func target():
	target_pos = get_global_mouse_position()
	gun.look_at(target_pos)
	
func shoot():
	if Input.is_action_just_pressed("shoot"):
		shoot_sound.play()
		var bullet = bullet_scene.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.look_at(target_pos)
		bullet.top_level = true
		add_child(bullet)

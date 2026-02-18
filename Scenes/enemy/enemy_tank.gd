extends PathFollow2D

@export var speed: float = 100
@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var detect_component: DetectComponent = $DetectComponent
@onready var trail_component: Node2D = $TrailComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)
	
func on_died():
	Gamemanager.entity_died.emit(global_position, get_groups())
	queue_free()
	
func on_get_damage(_damage):
	animation_player.play("flash")

func _process(delta: float) -> void:
	progress += speed * delta
	trail_component.start()
	find_player()
	
func find_player():
	var player_pos = detect_component.get_player_pos()
	if player_pos:
		weapon_component.target(player_pos)
		weapon_component.shoot(player_pos)

extends StaticBody2D

@onready var detect_component: DetectComponent = $DetectComponent
@onready var weapon_component: WeaponComponent = $WeaponComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent
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

func _process(_delta: float) -> void:
	find_player()
	
func find_player():
	if detect_component.can_see_player():
		var target_pos = detect_component.player_ref.global_position
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)

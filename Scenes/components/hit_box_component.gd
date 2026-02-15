class_name HitBoxComponent
extends Area2D

signal hit

@export var damage := 1
@export var hit_multiple := false

func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
func apply_hit(hurt_box: Area2D):
	if hurt_box.has_method("get_hurt"):
		hurt_box.get_hurt(damage)
	set_deferred("monitoring", hit_multiple)

func on_area_entered(area: Area2D):
	hit.emit()
	apply_hit(area)
	
func on_body_entered(_body: Node2D):
	hit.emit()

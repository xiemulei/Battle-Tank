class_name HurtBoxComponent
extends Area2D

signal get_damage(damage)

@export var armor :=  0

func get_hurt(damage: int):
	var final_damage = max(damage - armor, 0);
	get_damage.emit(final_damage)

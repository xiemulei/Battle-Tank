extends Node2D

@export var exp_anim_scene: PackedScene
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	Gamemanager.enemy_killed.connect(explode)
	
func explode(pos: Vector2):
	var exp_anim = exp_anim_scene	.instantiate()
	exp_anim.global_position = pos
	add_child(exp_anim)
	exp_anim.play("explosion")
	audio_stream_player.play()
	await exp_anim.animation_finished
	exp_anim.queue_free()
	

class_name TrailComponent
extends Node2D

@export var trail_scene: PackedScene
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(generate_trail)
	
func start():
	if timer.is_stopped():
		timer.start()
	
func stop():
	if not timer.is_stopped():
		timer.stop()
		
func generate_trail():
	var trail = trail_scene.instantiate()
	trail.global_position = owner.global_position
	trail.rotation = owner.rotation
	trail.top_level = true
	add_child(trail)

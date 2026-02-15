extends Node2D

@export var speed:float = 400
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent

func _ready() -> void:
	hit_box_component.hit.connect(on_hit)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)
	var tw = create_tween()
	tw.set_loops()
	tw.tween_property(self, "modulate", Color("ff6e00"), 0.2)
	tw.tween_property(self, "modulate", Color("ffffff"), 0.2)


func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
func on_hit():
	Gamemanager.bullet_hit.emit(global_position)
	queue_free()
	
func on_screen_exited():
	queue_free()

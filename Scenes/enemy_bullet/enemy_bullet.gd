extends Area2D

@export var speed: float = 100
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	area_entered.connect(on_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)

func on_area_entered(player: Player):
	if player.is_in_group("Player"):
		player.reduce_health()
		queue_free()

func on_screen_exited():
	queue_free()

func _process(delta: float) -> void:
	position += transform.x * speed * delta

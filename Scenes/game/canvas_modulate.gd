extends CanvasModulate

@export var map_colors: Array[Color]

func _ready() -> void:
	var index = Gamemanager.current_level - 1
	if index >= map_colors.size():
		index = Gamemanager.current_level % map_colors.size() - 1
	color = map_colors[index]

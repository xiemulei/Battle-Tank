extends Control

@onready var label: Label = $MarginContainer/HBoxContainer/PanelContainer/Label
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/ProgressBar

func _ready() -> void:
	Gamemanager.update_score_ui.connect(on_update_score_ui)
	Gamemanager.update_health_ui.connect(on_update_health_ui)
	on_update_score_ui(Gamemanager.score, Gamemanager.total_enemy_size)

func on_update_score_ui(score, total):
	label.text = "Killed: %s/%s" %[str(score), str(total)]

func on_update_health_ui(value: float):
	progress_bar.value = value

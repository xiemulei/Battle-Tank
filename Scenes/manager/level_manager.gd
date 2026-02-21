extends Node

@export var enemy_manager: Node
@export var map: Node2D

@onready var label: RichTextLabel = $CanvasLayer/Control/ContinuePanel/VBoxContainer/Label
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/ContinuePanel/VBoxContainer/AnimationPlayer
@onready var continue_panel: PanelContainer = $CanvasLayer/Control/ContinuePanel
@onready var continue_button: Button = $CanvasLayer/Control/ContinuePanel/VBoxContainer/ContinueButton
@onready var control: Control = $CanvasLayer/Control
@onready var timer: Timer = $Timer
@onready var win_panel: PanelContainer = $CanvasLayer/Control/WinPanel
@onready var loss_panel: PanelContainer = $CanvasLayer/Control/LossPanel
@onready var win_button: Button = $CanvasLayer/Control/WinPanel/VBoxContainer/WinButton
@onready var loss_button: Button = $CanvasLayer/Control/LossPanel/VBoxContainer/LossButton

func _ready() -> void:
	continue_button.pressed.connect(on_continue_pressed)
	win_button.pressed.connect(on_win_pressed)
	loss_button.pressed.connect(on_loss_pressed)
	Gamemanager.player_killed.connect(on_player_killed)
	Gamemanager.player_win.connect(on_player_win)
	pause_level()
	intro_anim()

func start_level():
	get_tree().paused = false

func pause_level():
	get_tree().paused = true

func intro_anim():
	control.show()
	continue_panel.show()
	win_panel.hide()
	loss_panel.hide()
	set_intro()
	continue_button.hide()
	animation_player.play("slow")
	await animation_player.animation_finished
	continue_button.show()

func set_intro():
	var data = enemy_manager.get_enemy_data()
	var text = "[center]Level %s[/center] \n There are %s attack waves and %s enemies." %[Gamemanager.current_level, data['wave'], data['enemy']]
	text += "\n kill them all and survive!"
	label.text = text

func on_continue_pressed():
	Gamemanager.level_start.emit()
	continue_panel.hide()
	control.hide()
	start_level()
	SoundManager.player_click()

func on_player_killed():
	timer.start()
	await  timer.timeout
	control.show()
	loss_panel.show()

func on_player_win():
	timer.start()
	await timer.timeout
	control.show()
	win_panel.show()

func on_win_pressed():
	control.hide()
	win_panel.hide()
	next_level()
	SoundManager.player_click()

func next_level():
	Gamemanager.next_level()
	Gamemanager.reset_score()
	get_tree().reload_current_scene()

func on_loss_pressed():
	Gamemanager.to_menu()
	SoundManager.player_click()

extends Control

@onready var start_button: Button = $TextureRect/MarginContainer/VBoxContainer/PanelContainer/StartButton
@onready var quit_button: Button = $TextureRect/MarginContainer/VBoxContainer/PanelContainer2/QuitButton

func _ready() -> void:
	start_button.pressed.connect(on_start_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	start_button.mouse_entered.connect(on_mouse_enter)
	quit_button.mouse_entered.connect(on_mouse_enter)
	SoundManager.play_music()
	SoundManager.change_music_vol(0)

func on_start_pressed():
	SoundManager.change_music_vol(-20)
	SoundManager.play_click()
	Gamemanager.to_game()

func on_quit_pressed():
	SoundManager.play_click()
	await  SoundManager.sound.finished
	get_tree().quit()

func on_mouse_enter():
	SoundManager.play_hover()

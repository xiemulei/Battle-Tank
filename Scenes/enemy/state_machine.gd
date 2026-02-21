extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	
	# 等待导航服务就绪
	set_physics_process(false)
	await  get_tree().create_timer(0.1).timeout
	set_physics_process(true)

func on_child_transition(state: State, new_state_name: StringName):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name)
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

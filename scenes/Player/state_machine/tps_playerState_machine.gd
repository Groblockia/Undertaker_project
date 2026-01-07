extends RefCounted

class_name TPSPlayerStateMachine

var states: Dictionary = {}
var current_state: TPSPlayerStateInterface
var current_state_name: String = ""
var owner: TPSPlayer

func add_state(name: String, state: TPSPlayerStateInterface) -> void:
	states[name.to_lower()] = state
	state.state_machine = self

func set_initial_state(state_name: String) -> void:
	change_state(state_name)

func change_state(new_state_name: String) -> void:
	var prev_state_name := current_state_name
	if current_state:
		current_state.exit()
	
	current_state_name = new_state_name.to_lower()
	current_state = states.get(current_state_name)
	
	if current_state:
		current_state.enter(prev_state_name)
	else:
		push_warning("state not found: " + new_state_name)

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func get_current_state_name() -> String:
	return current_state_name

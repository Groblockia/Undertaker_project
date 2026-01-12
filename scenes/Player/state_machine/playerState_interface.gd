extends RefCounted
class_name  PlayerStateInterface

var state_machine: PlayerStateMachine

func enter(_prev_state: String = "") -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent)-> void:
	pass

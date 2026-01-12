extends PlayerStateInterface

##handles the player sprinting state
class_name PlayerSprintState

var op: Player

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "sprint"


func physics_update(delta: float) -> void:
	if !op.is_moving:
		state_machine.change_state("player_idle")
	
	if Input.is_action_just_released("sprint"):
		state_machine.change_state("player_move")
	
	#move character
	op.move(delta, op.SPRINT_SPEED, op.ACCELERATION_SPEED)
	
	if !op.is_on_floor():
		state_machine.change_state("player_fall")


func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("player_jumpCharge")

extends PlayerStateInterface

##handles the player idle state
class_name PlayerIdleState

var op: Player

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "idle"


func physics_update(delta: float) -> void:
	op.move(delta, op.SPEED, op.DECCELERATION_SPEED)
	
	if !op.is_on_floor():
		state_machine.change_state("player_fall")


func handle_input(_event: InputEvent) -> void:
	if op.is_moving:
		state_machine.change_state("player_move")
	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("player_jumpCharge")

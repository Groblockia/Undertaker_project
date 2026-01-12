extends PlayerStateInterface

##handles the player moving state
class_name PlayerMoveState

var op: Player

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "move"


func physics_update(delta: float) -> void:
	if !op.is_moving:
		state_machine.change_state("player_idle")
		
	if Input.is_action_pressed("sprint"):
		state_machine.change_state("player_sprint")
	
	#move character
	op.move(delta, op.SPEED, op.ACCELERATION_SPEED)
	
	if !op.is_on_floor():
		state_machine.change_state("player_fall")


func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("player_jumpCharge")

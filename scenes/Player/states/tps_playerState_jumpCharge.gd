extends TPSPlayerStateInterface

class_name TPSPlayerJumpChargeState

var op: TPSPlayer
var current_charge_time: float

const CHARGE_THRESHOLD: float = 0.25
var time_held: float

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	#print("entering jumpCharge state")
	current_charge_time = op.DEF_JUMP_VELOCITY
	time_held = 0
	Debug.player_state = "jumpCharge"

func physics_update(delta: float) -> void:
	
	time_held += delta
	
	if Input.is_action_pressed("jump"):
		if time_held > CHARGE_THRESHOLD:
			current_charge_time += delta * 15
			current_charge_time = clamp(current_charge_time, 0.0, op.MAX_JUMP_VELOCITY)
			
			op.move(delta, op.CHARGING_SPEED)
			
			Debug.generic_value = str(snapped(current_charge_time, 0.01))
			
		else:
			op.move(delta, op.SPEED)

	if Input.is_action_just_released("jump"):
		Debug.generic_value = str(snapped(current_charge_time, 0.01))
		op.current_jump_value = current_charge_time
		state_machine.change_state("player_jump")
	

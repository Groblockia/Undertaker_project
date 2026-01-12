extends PlayerStateInterface

##decides how much jump power to give the player based on how long they hold the jump button
class_name PlayerJumpChargeState
var op: Player

#time before the jump starts charging
const CHARGE_THRESHOLD: float = 0.25

var current_jump_force: float
var time_held: float

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "jumpCharge"
	current_jump_force = op.DEF_JUMP_VELOCITY
	time_held = 0


func physics_update(delta: float) -> void:
	time_held += delta
	
	#if jump is held long enough, start charging the jump
	if time_held > CHARGE_THRESHOLD:
		current_jump_force += delta * op.JUMP_CHARGE_SPEED
		current_jump_force = clamp(current_jump_force, 0.0, op.MAX_JUMP_VELOCITY)
		
		#movement speed while charging the jump
		op.move(delta, op.CHARGING_SPEED)
		
		Debug.generic_value = str(snapped(current_jump_force, 0.01))

	#when not charging, move at normal speed
	else:
		op.move(delta, op.SPEED)

	if Input.is_action_just_released("jump"):
		Debug.generic_value = str(snapped(current_jump_force, 0.01))

		if time_held > CHARGE_THRESHOLD:
			op.current_jump_value = current_jump_force
			state_machine.change_state("player_jump")
		
		else:
			if op.can_dash:
				state_machine.change_state("player_dash")

			else:
				print("Dash on cooldown, cannot dash.")
				#transition to appropriate state
				if op.is_on_floor():
					if op.is_moving:
						if Input.is_action_pressed("sprint"):
							state_machine.change_state("player_sprint")
						else:
							state_machine.change_state("player_move")
					else:
						state_machine.change_state("player_idle")
				else:
					state_machine.change_state("player_fall")
	

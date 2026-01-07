extends TPSPlayerStateInterface

class_name TPSPlayerFallState

var op: TPSPlayer

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	#print("entering fall state")
	Debug.player_state = "fall"

func physics_update(delta: float) -> void:
	op.velocity.y -= op.gravity * delta
	op.move(delta, op.SPEED, op.AIR_DECCEL_SPEED)
	
	if op.is_on_floor():
		#if trying to move:
		if Input.get_vector("forward", "backward", "left", "right") != Vector2.ZERO:
			state_machine.change_state("player_move")
		else:
			state_machine.change_state("player_idle")

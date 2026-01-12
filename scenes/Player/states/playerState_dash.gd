extends PlayerStateInterface

##applies the jump to the player based on the charged jump power when jump key is released
class_name PlayerDashState

var op: Player
var prev_velocity: Vector3
var prev_dir: Vector3
var dash_time: float


func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "dash"

	#store velocity and jump at start of jump
	prev_velocity = op.velocity
	prev_dir = op.direction

	dash_time = 0.0

	op.can_dash = false
	op.dash_cooldown_timer.start()


func physics_update(delta: float) -> void:
	dash_time += delta

	#apply slowed movement while dashing
	#op.move(delta, op.SPEED, op.DECCELERATION_SPEED)

	if dash_time < op.DASH_DURATION:
		op.move_specificDir(delta, op.DASH_SPEED, prev_dir, op.DASH_ACCELERATION)
		op.velocity += prev_velocity

	else:
		#transition to other states after dash ends
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


	
	

extends PlayerStateInterface

##applies the jump to the player based on the charged jump power when jump key is released
class_name PlayerJumpState

var op: Player
var prev_velocity: Vector3
var final_angle: float

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "jump"

	#store velocity and jump at start of jump
	prev_velocity = op.velocity
	var input_dir = op.direction
	final_angle = op.JUMP_ANGLE_DEG
	
	#if no movement input, make the jump vertical only
	if !op.is_moving():
		input_dir = Vector3.ZERO
		final_angle = 90.0
	
	#calculate jump vector
	var angle_rad = deg_to_rad(final_angle)
	var vertical_power = sin(angle_rad) 
	var horizontal_power = cos(angle_rad)
	var jump_vector_y = Vector3.UP * vertical_power
	var jump_vector_h = input_dir * horizontal_power
	var launch_vector = (jump_vector_y + jump_vector_h).normalized() * op.current_jump_value
	
	#apply jump
	op.velocity = launch_vector
	op.velocity += prev_velocity


func physics_update(delta: float) -> void:
	#apply gravity and movement while in the air
	op.velocity.y -= op.gravity * delta
	op.move(delta, op.SPEED, op.AIR_DECCEL_SPEED)
	
	#transition to fall state when falling down
	if op.velocity.y <= 0:
		state_machine.change_state("player_fall")

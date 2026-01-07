extends TPSPlayerStateInterface

class_name TPSPlayerJumpState

var op: TPSPlayer
var vertical_part: Vector3
var horizontal_part: Vector3
var prev_velocity
var final_angle: float

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	#print("entering jump state")
	Debug.player_state = "jump"
	prev_velocity = op.velocity
	
	# 1. On récupère la direction d'INPUT (et non la vitesse actuelle qui est lente)
	# On normalise pour être sûr d'avoir une longueur de 1
	var input_dir = op.direction

	final_angle = op.JUMP_ANGLE_DEG
	
	#saut sur place:
	if input_dir.length_squared() < 0.1:
		input_dir = Vector3.ZERO # Pas de composante horizontale
		final_angle = 90.0 # Force le saut à la verticale
	
	var angle_rad = deg_to_rad(final_angle)
	var vertical_power = sin(angle_rad) 
	var horizontal_power = cos(angle_rad)
	
	var jump_vector_y = Vector3.UP * vertical_power
	var jump_vector_h = input_dir * horizontal_power
	
	var launch_vector = (jump_vector_y + jump_vector_h).normalized() * op.current_jump_value
	
	op.velocity = launch_vector
	op.velocity += prev_velocity
	
	#vertical_part = Vector3.UP * op.current_jump_value
	#horizontal_part = Vector3.ZERO
	#
	#if op.direction.length_squared() > 0:
		#horizontal_part = op.direction * op.jump_forward_impulse
	#
	#op.velocity.y = 0
	#op.velocity = Vector3(op.velocity.x, 0, op.velocity.z) + horizontal_part + vertical_part

func physics_update(delta: float) -> void:
	op.velocity.y -= op.gravity * delta
	op.move(delta, op.SPEED, op.AIR_DECCEL_SPEED)
	
	if op.velocity.y <= 0:
		state_machine.change_state("player_fall")

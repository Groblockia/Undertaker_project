extends CharacterBody3D
class_name TPSPlayer

var player_can_move := true:
	set(value): 
		player_can_move = value
		if value == false: pause_all_movements()
		else: velocity = prev_vel

var state_machine: TPSPlayerStateMachine
var gravity := 9.8 * 4
var direction: Vector3
var input_dir: Vector2
var prev_vel: Vector3

@export var SPEED: float = 6.0
@export var SPRINT_SPEED: float = 12.0
@export var ACCELERATION_SPEED: float = 6.0
@export var DECCELERATION_SPEED: float = 6.0
@export var AIR_DECCEL_SPEED: float = 2.0
@export var CHARGING_SPEED: float = 2.0
@export var DEF_JUMP_VELOCITY: float = 20.0
@export var MAX_JUMP_VELOCITY: float = 40.0
#@export var jump_forward_impulse : float = 20.0
@export_range(0,90) var JUMP_ANGLE_DEG: float = 45.0
@onready var current_jump_value: float

@onready var head :Node3D = $head
@onready var state_label = $Control/state_label
@onready var collision_mesh = $CollisionShape3D
@onready var geometry_mesh = $mech_prototype

func _ready() -> void:
	state_machine = TPSPlayerStateMachine.new()
	state_machine.owner = self
	
	#create and add states to use
	state_machine.add_state("player_idle", TPSPlayerIdleState.new())
	state_machine.add_state("player_move", TPSPlayerMoveState.new())
	state_machine.add_state("player_jump", TPSPlayerJumpState.new())
	state_machine.add_state("player_fall", TPSPlayerFallState.new())
	state_machine.add_state("player_sprint", TPSPlayerSprintState.new())
	state_machine.add_state("player_JumpCharge", TPSPlayerJumpChargeState.new())
	
	state_machine.set_initial_state("player_idle")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.update(delta)
	
	#toggle mouse cursor
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player_can_move = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			player_can_move = true
	
	#show current state and jump values
	state_label.text = Debug.player_state
	$Control/Label.text = Debug.generic_value
	

func _physics_process(delta: float) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.physics_update(delta)
		get_movement_direction()
		rotate_with_head()
	
	


func _input(event: InputEvent) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.handle_input(event)
	
	#if Input.is_action_just_pressed("interact"):
		#interaction()

func get_current_state() -> String:
	return state_machine.get_current_state_name()

func pause_all_movements() -> void:
	prev_vel = velocity
	velocity = Vector3(0,0,0)
	state_machine.change_state("player_idle")

#func interaction() -> void:
	#@warning_ignore("unsafe_method_access", "untyped_declaration")
	#var col = interact_ray.get_collider()
	#if col is InteractionArea:
		#@warning_ignore("unsafe_method_access")
		#col.interact(self)

func get_movement_direction():
	input_dir = (Input.
	get_vector("left", "right", "forward", "backward"))
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, head.rotation.y)

func move(delta: float, speed: float, accel: float = 6.0) -> void:
	velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	
	move_and_slide()

func rotate_with_head() -> void:
	#print("model rotation.y = ", snapped(rad_to_deg(geometry_mesh.rotation.y),0.01), ", head rotation.y = ", snapped(rad_to_deg(head.rotation.y),0.01) )
	geometry_mesh.rotation.y = lerp_angle(geometry_mesh.rotation.y, head.rotation.y, 0.3)
	collision_mesh.rotation.y = head.rotation.y

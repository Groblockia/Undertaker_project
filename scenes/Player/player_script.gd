extends CharacterBody3D

##Player Character Script
class_name Player

@export_group("Movement Stats")
@export_category("regular movement stats")
##default move speed
@export var SPEED: float = 6.0
##default sprint speed
@export var SPRINT_SPEED: float = 12.0
##default acceleration speed
@export var ACCELERATION_SPEED: float = 6.0
##default deceleration speed
@export var DECCELERATION_SPEED: float = 6.0
##default air deceleration speed
@export var AIR_DECCEL_SPEED: float = 2.0

@export_category("jump related stats")
##default move speed while charging a jump
@export var CHARGING_SPEED: float = 5.0
##default jump velocity
@export var DEF_JUMP_VELOCITY: float = 20.0
##maximum jump velocity
@export var MAX_JUMP_VELOCITY: float = 40.0
##charged jump charging speed
@export var JUMP_CHARGE_SPEED: float = 15.0
##jump angle in degrees
@export_range(0,90) var JUMP_ANGLE_DEG: float = 45.0

@export_category("dash related stats")
##dashing speed
@export var DASH_SPEED: float = 50.0
##dash duration
@export var DASH_DURATION: float = 0.2
##dash acceleration
@export var DASH_ACCELERATION: float = 100
##dash cooldown time
@export var DASH_COOLDOWN: float = 1.0

@export_category("other stats")
##gravity force multiplier
@export var GRAVITY_MULTIPLIER: float = 4.0


@onready var head :Node3D = %head
@onready var state_label = $ui/state_label
@onready var collision_mesh = $CollisionShape3D
@onready var geometry_mesh = %mech_model
@onready var dash_cooldown_timer: Timer = $DashTimer
@onready var interact_shape = %Interaction_shape


var current_jump_value: float
var can_dash: bool = true
var state_machine: PlayerStateMachine
var gravity := 9.8 * GRAVITY_MULTIPLIER
var direction: Vector3
var input_dir: Vector2
var prev_vel: Vector3
var player_can_move := true:
	set(value): 
		player_can_move = value
		if value == false: pause_all_movements()
		else: velocity = prev_vel
var items_colliding: Array
var distance_item_player: Array
var closest_item: Object


func _ready() -> void:
	state_machine = PlayerStateMachine.new()
	state_machine.owner = self
	
	#create and add states to use
	state_machine.add_state("player_idle", PlayerIdleState.new())
	state_machine.add_state("player_move", PlayerMoveState.new())
	state_machine.add_state("player_jump", PlayerJumpState.new())
	state_machine.add_state("player_dash", PlayerDashState.new())
	state_machine.add_state("player_fall", PlayerFallState.new())
	state_machine.add_state("player_sprint", PlayerSprintState.new())
	state_machine.add_state("player_JumpCharge", PlayerJumpChargeState.new())
	
	state_machine.set_initial_state("player_idle")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	#intialize dash timer
	dash_cooldown_timer.wait_time = DASH_COOLDOWN

func _process(delta: float) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.update(delta)
	
	if Input.is_action_just_pressed("tab"):
		toggle_mouse_cursor()
	
	#show current state and jump values on screen
	state_label.text = Debug.player_state
	$ui/Label.text = Debug.generic_value
	
	interact_with_item()
	hover_on_closest()

func _physics_process(delta: float) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.physics_update(delta)

		get_movement_direction()
		rotate_with_head()

func _unhandled_input(event: InputEvent) -> void:
	if player_can_move: #run corresponding state machine function
		state_machine.handle_input(event)

func get_current_state() -> String:
	return state_machine.get_current_state_name()

func pause_all_movements() -> void:
	prev_vel = velocity
	velocity = Vector3(0,0,0)
	state_machine.change_state("player_idle")

func toggle_mouse_cursor() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player_can_move = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player_can_move = true

func is_moving() -> bool:
	return Input.get_vector("forward", "backward", "left", "right") != Vector2.ZERO

func get_movement_direction() -> void:
	input_dir = (Input.get_vector("left", "right", "forward", "backward"))
	#calculate movement direction based on input direction then rotated by head rotation
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, head.rotation.y)

##moves the player character based on input direction, speed, and acceleration
func move(delta: float, speed: float, accel: float = 6.0) -> void:
	velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	
	move_and_slide()

##moves the player character based on a specific direction, speed, and acceleration
func move_specificDir(delta: float, speed: float, single_direction:Vector3 , accel: float = 6.0) -> void:
	velocity.x = lerp(velocity.x, single_direction.x * speed, delta * accel)
	velocity.z = lerp(velocity.z, single_direction.z * speed, delta * accel)
	
	move_and_slide()

##rotates the player model to match the head direction
func rotate_with_head() -> void:
	geometry_mesh.rotation.y = lerp_angle(geometry_mesh.rotation.y, head.rotation.y, 0.3)
	collision_mesh.rotation.y = head.rotation.y

##send interact signal to closest Interactable
func interact_with_item() -> void:
	items_colliding = interact_shape.get_overlapping_bodies()
	if Input.is_action_just_pressed("interact"):
		Interaction_Manager.process_interact(distance_item_player[0].collider)

##sorts all items in range from closest to farthest in `distance_item_player` array
func sort_items_by_closest():
	distance_item_player.clear()
	for x in items_colliding.size():
		distance_item_player.append({"distance": %middle_point.global_position.distance_to(items_colliding[x].global_position), "collider": items_colliding[x] })
	distance_item_player.sort_custom(func(a, b): return a["distance"] < b["distance"])

##send hover signal only to closest item
func hover_on_closest() -> void:
	sort_items_by_closest()
	if !distance_item_player.is_empty():
		Interaction_Manager.hover_on(distance_item_player[0].collider)
		#print(distance_item_player)
		for x in range(1, distance_item_player.size()):
			Interaction_Manager.hover_off(distance_item_player[x].collider)

##tells item they cannot be hovered anymore
func _on_interaction_shape_body_exited(body: Node3D) -> void:
	if body is Interactable:
		Interaction_Manager.hover_off(body)

func _on_dash_timer_timeout() -> void:
	can_dash = true

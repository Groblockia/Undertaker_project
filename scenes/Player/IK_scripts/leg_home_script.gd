extends Marker3D

@export_group("References")
@export var home_raycast: RayCast3D # The Raycast parented to the body (Part 2)
@export var body: CharacterBody3D   # Reference to the main player body

@export_group("Settings")
@export var step_distance: float = 0.5
@export var step_height: float = 0.3
@export var step_duration: float = 0.15
@export var velocity_multiplier: float = 0.5 # "Overshoot" prediction

var is_moving: bool = false

func _ready() -> void:
	# Detach from parent to stay in world space if setup incorrectly, 
	# but ideally, this node is already top-level or unparented from the moving body.
	top_level = true 

func _process(_delta: float) -> void:
	# 1. Calculate the "Ideal" position (where the foot WANTS to be)
	# We use the Raycast to find the ground below the "Home" marker
	var ideal_pos: Vector3

	if home_raycast.is_colliding():
		ideal_pos = home_raycast.get_collision_point()
	else:
		# Fallback if in air
		ideal_pos = home_raycast.global_position - Vector3(0, -1, 0)

	# 2. Check distance between Current Position (stuck to ground) and Ideal Position (moving with body)
	var dist = global_position.distance_to(ideal_pos)

	# 3. Trigger Step if too far and not already stepping
	if dist > step_distance and not is_moving:
		# Predict movement: Add velocity to land in front of the movement
		var overshoot = body.velocity * velocity_multiplier
		# Flatten overshoot to ground plane (optional)
		overshoot.y = 0 
		
		step_to(ideal_pos + overshoot)

func step_to(target_pos: Vector3) -> void:
	is_moving = true
	
	var tween = create_tween()
	tween.set_parallel(false) # Run sequentially for arc? No, we need parallel for height/pos
	
	# Simple arc movement: 
	# We can't easily do a perfect curve with one tween property, 
	# so we tween position linear and add a height offset method, 
	# OR just use a simple "Up then Down" method for brevity.
	
	# Method: Tween Value with a Curve (Cleanest)
	var initial_pos = global_position
	var mid_pos = (initial_pos + target_pos) / 2.0 + Vector3(0, step_height, 0)
	
	# Tween using a custom method to interpolate quadratic bezier
	tween.tween_method(
		func(t): global_position = _quadratic_bezier(initial_pos, mid_pos, target_pos, t),
		0.0, 
		1.0, 
		step_duration
	).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	is_moving = false

# Helper for the arc
func _quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float) -> Vector3:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	return q0.lerp(q1, t)

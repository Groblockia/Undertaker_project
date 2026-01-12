extends Node3D

#@export_group("FOV")
#@export var change_fov_on_run : bool
#@export var normal_fov : float = 75.0
#@export var run_fov : float = 90.0
#
#const CAMERA_BLEND : float = 0.05

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var player: Player = get_parent()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if player.player_can_move:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.005)
			spring_arm.rotate_x(-event.relative.y * 0.005)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)


##TESTING
#@export var mouse_sensitivity: float = 0.005
#
## Store the mouse input here
#var mouse_input: Vector2 = Vector2.ZERO
#
#
#func _input(event: InputEvent) -> void:
	#if player.player_can_move:
		#if event is InputEventMouseMotion:
			## Accumulate mouse input 
			#mouse_input += event.relative
#
#func _process(_delta: float) -> void:
	#if player.player_can_move:
		## apply accumulated mouse inpit
		#if mouse_input != Vector2.ZERO:
			#self.rotate_y(-mouse_input.x * mouse_sensitivity)
			#spring_arm.rotate_x(-mouse_input.y * mouse_sensitivity)
			##limit up/down movement
			#spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, -PI/4)
			#
			## Reset input for the next frame
			#mouse_input = Vector2.ZERO

#func _physics_process(_delta: float) -> void:
	#if change_fov_on_run:
		#@warning_ignore("unsafe_method_access")
		#if owner.is_on_floor():
			#if Input.is_action_pressed("run"):
				#camera.fov = lerp(camera.fov, run_fov, CAMERA_BLEND)
			#else:
				#camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
		#else:
			#camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)

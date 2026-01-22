extends Node3D

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var player: Player = get_parent()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if player.player_can_move:
		if event is InputEventMouseMotion:
			# Rotate the head and camera based on mouse movement
			rotate_y(-event.relative.x * 0.005)
			spring_arm.rotate_x(-event.relative.y * 0.005)
			# Clamp the vertical rotation to prevent flipping
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/4)

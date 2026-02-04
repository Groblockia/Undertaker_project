extends Node3D

@onready var parent := $".."
@onready var head := %head
@onready var mesh := %mech_model

# ik targets
@onready var ik_targets_container := $IkTargets
@onready var front_left  := $IkTargets/FrontLeftMarker
@onready var front_right := $IkTargets/FrontRightMarker
@onready var back_left   := $IkTargets/BackLeftMarker
@onready var back_right  := $IkTargets/BackRightMarker

# Ik homes
@onready var ik_current_container := $IkCurrentTargets
@onready var front_left_current  := $IkCurrentTargets/FrontLeftCurrent
@onready var front_right_current := $IkCurrentTargets/FrontRightCurrent
@onready var back_left_current   := $IkCurrentTargets/BackLeftCurrent
@onready var back_right_current  := $IkCurrentTargets/BackRightCurrent

# magnets to keep middle joints upwards
#@onready var magnets_container := $Magnets
#@onready var magnet_Fr_L := $Magnets/FrontLeftMagnet
#@onready var magnet_Fr_R := $Magnets/FrontRightMagnet
#@onready var magnet_Bk_L := $Magnets/BackLeftMagnet
#@onready var magnet_Bk_R := $Magnets/BackRightMagnet

# position of ik targets
@export var width: float  = 2.5 # left/right distance
@export var length: float = 2.0 # front/back distance
@export var height: float = 0.5 # up/down distance
@export var Zoffset: float = 0.0 # offset everything front/back

# misc
@export var position_speed: float = 5.0

func _ready() -> void:
	setup_marker_positions()

func _process(delta: float) -> void:
	calculate_marker_positions(delta)
	step()

func setup_marker_positions() -> void:
	#ik_targets_container.rotation = head.rotation
	# Position = Vector3(left/right, height, front/back)
	front_left.position  = ( Vector3(-width, height, -length) + Vector3(0,0,Zoffset) )
	front_right.position = ( Vector3(width, height, -length) + Vector3(0,0,Zoffset) )
	back_left.position   = ( Vector3(-width, height, length) + Vector3(0,0,Zoffset) )
	back_right.position  = ( Vector3(width, height, length) + Vector3(0,0,Zoffset) )

func calculate_marker_positions(delta: float) -> void:
	ik_targets_container.rotation.y = lerp_angle(ik_targets_container.rotation.y, head.rotation.y, delta * position_speed)
	#magnets_container.rotation.y 	= lerp_angle(magnets_container.rotation.y, head.rotation.y, delta * position_speed)

	# direction * basis = local to global, direction * basis.inverse() = global to local
	var local_lean = ik_targets_container.global_transform.basis.inverse() * ((parent.velocity * 0.5).clamp(Vector3(-1.5, -1.5, -1.5), Vector3(1.5, 1.5, 1.5)))

	front_left.position = lerp(front_left.position, 
		( Vector3(-width, height, -length) + Vector3(0,0,Zoffset) ) + (local_lean), 
		delta * position_speed)

	front_right.position = lerp(front_right.position, 
		( Vector3(width, height, -length) + Vector3(0,0,Zoffset) ) + (local_lean), 
		delta * position_speed)

	back_left.position = lerp(back_left.position, 
		( Vector3(-width, height, length) + Vector3(0,0,Zoffset) ) + (local_lean), 
		delta * position_speed)

	back_right.position = lerp(back_right.position, 
		( Vector3(width, height, length) + Vector3(0,0,Zoffset) ) + (local_lean), 
		delta * position_speed)

func step():
	front_left_current.position  = front_left.global_position
	front_right_current.position = front_right.global_position
	back_left_current.position   = back_left.global_position
	back_right_current.position  = back_right.global_position

extends Node3D

@onready var parent := $".."
@onready var head := $"../head"
@onready var mesh := $"../mech"

# ik targets
@onready var ik_targets_container := $IkTargets
@onready var front_left  := $IkTargets/FrontLeftMarker
@onready var front_right := $IkTargets/FrontRightMarker
@onready var back_left   := $IkTargets/BackLeftMarker
@onready var back_right  := $IkTargets/BackRightMarker

# magnets to keep middle joints upwards
@onready var magnets_container := $Magnets
@onready var magnet_Fr_L := $Magnets/FrontLeftMagnet
@onready var magnet_Fr_R := $Magnets/FrontRightMagnet
@onready var magnet_Bk_L := $Magnets/BackLeftMagnet
@onready var magnet_Bk_R := $Magnets/BackRightMagnet

# position of ik targets
@export var width: float  = 1.5 # left/right distance
@export var length: float = 2.0 # front/back distance
@export var height: float = 0.5 # up/down distance
@export var Zoffset: float = 0.0 # offset everything front/back

# misc
@export var position_speed: float = 5.0

func _ready():
	setup_marker_positions()

func _process(delta: float) -> void:
	calculate_marker_positions(delta)

func setup_marker_positions():
	ik_targets_container.rotation = head.rotation
	# Position = Vector3(left/right, height, front/back)
	front_left.position  = ( Vector3(-width, height, -length) + Vector3(0,0,Zoffset) )
	front_right.position = ( Vector3(width, height, -length) + Vector3(0,0,Zoffset) )
	back_left.position   = ( Vector3(-width, height, length) + Vector3(0,0,Zoffset) )
	back_right.position  = ( Vector3(width, height, length) + Vector3(0,0,Zoffset) )

func calculate_marker_positions(delta: float):
	
	ik_targets_container.rotation = lerp(ik_targets_container.rotation, head.rotation, delta * position_speed)

	# direction * basis = local to global, direction * basis.inverse() = global to local
	var local_lean = ik_targets_container.global_transform.basis.inverse() * parent.direction

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

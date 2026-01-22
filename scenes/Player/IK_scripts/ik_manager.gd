extends Node3D


@onready var top_current_front_left: Node3D = $"../IkTargets/Current/top/front_left"
@onready var top_current_front_right: Node3D = $"../IkTargets/Current/top/front_right"
@onready var top_current_back_left: Node3D = $"../IkTargets/Current/top/back_left"
@onready var top_current_back_right: Node3D = $"../IkTargets/Current/top/back_right"

@onready var end_current_front_left: Node3D = $"../IkTargets/Current/end/front_left"
@onready var end_current_front_right: Node3D = $"../IkTargets/Current/end/front_right"
@onready var end_current_back_left: Node3D = $"../IkTargets/Current/end/back_left"
@onready var end_current_back_right: Node3D = $"../IkTargets/Current/end/back_right"


@onready var top_predicted_front_left: Node3D = $"../IkTargets/Predicted/top/front_left"
@onready var top_predicted_front_right: Node3D = $"../IkTargets/Predicted/top/front_right"
@onready var top_predicted_back_left: Node3D = $"../IkTargets/Predicted/top/back_left"
@onready var top_predicted_back_right: Node3D = $"../IkTargets/Predicted/top/back_right"

@onready var end_predicted_front_left: Node3D = $"../IkTargets/Predicted/end/front_left"
@onready var end_predicted_front_right: Node3D = $"../IkTargets/Predicted/end/front_right"
@onready var end_predicted_back_left: Node3D = $"../IkTargets/Predicted/end/back_left"
@onready var end_predicted_back_right: Node3D = $"../IkTargets/Predicted/end/back_right"

@export var mech: Node3D
@export var parent: Node3D

var step_size: float = 2.5

#array containing all end_predicted targets
var end_predicted_targets: Array[Node3D] = []

func _ready():
	#add all end_predicted targets to the array
	end_predicted_targets.append(end_predicted_front_left)
	end_predicted_targets.append(end_predicted_front_right)
	end_predicted_targets.append(end_predicted_back_left)
	end_predicted_targets.append(end_predicted_back_right)
	move_all()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		check_distance(end_current_front_left, end_predicted_front_left)
		move_all()
	for i in end_predicted_targets:
		i.global_position = parent.global_position + parent.direction * 2.0

func _physics_process(delta: float) -> void:
	$"../IkTargets/Predicted".rotation = mech.rotation
	if check_distance(end_current_front_left, end_predicted_front_left):
		move_all()

func move_current_to_predicted(target_to_move: Node3D, target: Node3D) -> void:
	target_to_move.global_transform = target.global_transform

func move_all():
	move_current_to_predicted(end_current_front_left, end_predicted_front_left)
	move_current_to_predicted(end_current_front_right, end_predicted_front_right)
	move_current_to_predicted(end_current_back_left, end_predicted_back_left)
	move_current_to_predicted(end_current_back_right, end_predicted_back_right)
	move_current_to_predicted(top_current_front_left, top_predicted_front_left)
	move_current_to_predicted(top_current_front_right, top_predicted_front_right)
	move_current_to_predicted(top_current_back_left, top_predicted_back_left)
	move_current_to_predicted(top_current_back_right, top_predicted_back_right)

func check_distance(initial: Node3D, target: Node3D) -> bool:
	if initial.global_transform.origin.distance_to(target.global_transform.origin) >= step_size:
		return true
	return false

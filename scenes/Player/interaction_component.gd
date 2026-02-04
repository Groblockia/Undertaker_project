extends Node3D

@onready var shapeCast = %Interaction_shape

func _ready() -> void:
	pass

func interact():
	var col: Object = null
	
	if shapeCast.is_colliding():
		col = shapeCast.get_collider(0)
		
	if col != null:
		Interaction_Manager.process_interact(col)

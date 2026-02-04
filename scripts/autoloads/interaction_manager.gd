extends Node

## send interaction call to object
func process_interact(collided: Object)-> void:
	if collided is Interactable:
		if collided.has_method("interacted"):
			collided.interacted()

func hover_on(collided: Object) -> void:
	collided.hover_on()

func hover_off(collided: Object)-> void:
	collided.hover_off()

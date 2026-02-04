extends Node

#signal interaction

func process_interact(collided: Object):
	if collided is Interactable:
		if collided.has_method("interacted"):
			collided.interacted()

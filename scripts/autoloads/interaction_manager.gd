extends Node

#signal interaction

func process_interact(collided: Object):
	if collided is Interactable:
		if collided.has_method("interacted"):
			collided.interacted()

func hover_start(collided: Object):
	if collided is Interactable:
		if collided.has_method("hover_start"):
			collided.hover_start()

func hover_stop(collided: Object):
	if collided is Interactable:
		if collided.has_method("hover_stop"):
			collided.hover_stop()

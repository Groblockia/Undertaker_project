extends Node3D
class_name Interactable

## do whatever needs to be done when interacted
func interacted():
	print("don't forget to override the interacted() function")
	pass

func hover_start():
	print("don't forget to override the hover_start() function")

func hover_stop():
	print("don't forget to override the hover_stop() function")

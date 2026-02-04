extends Node3D
class_name Interactable

## do whatever needs to be done when interacted
func interacted() -> void:
	print("don't forget to override the interacted() function")

func hover_on() -> void:
	print("don't forget to override the hover_on() function")

func hover_off() -> void:
	print("don't forget to override the hover_off() function")

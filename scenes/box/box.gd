extends Interactable

@onready var label = $Label3D

func interacted() -> void:
	print(self.name," has received interaction")

func hover_on() -> void:
	label.show()

func hover_off() -> void:
	label.hide()

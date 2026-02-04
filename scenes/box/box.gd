extends Interactable

@onready var label = $Label3D

func interacted():
	print(self.name," has received interaction")

func hover_start():
	label.show()

func hover_stop():
	label.hide()

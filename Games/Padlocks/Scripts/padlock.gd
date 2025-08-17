extends TextureButton

@export var life : int = 10

var open : bool = false

func _on_pressed() -> void:
	life -= 1
	if life == 0:
		self.disabled = true
		open = true
		print(self.name, "Disabled", self.disabled)
	pass # Replace with function body.

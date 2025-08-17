extends Node2D

func _ready() -> void:
	print("Loaded bugs")

func _process(delta: float) -> void:
	if self.get_child_count() <= 2: # El contador representa el número de elementos que no son "bichos".
		$ProgressBar._next_scene()

extends Node2D

func _ready() -> void:
	print("Loaded bugs")

func _process(delta: float) -> void:
	if self.get_child_count() <= 1:
		$ProgressBar._next_scene()

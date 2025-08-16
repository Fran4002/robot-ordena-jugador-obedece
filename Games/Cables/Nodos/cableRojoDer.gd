extends Node2D

signal cableRojoDer_cliked

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clic detectado en calbeRojoDer")
		emit_signal("cableRojoDer_cliked")

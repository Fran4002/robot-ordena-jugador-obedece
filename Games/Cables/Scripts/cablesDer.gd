extends Node2D

# señales que recibira cada color para hacer match
signal cableRojoDer_cliked
signal cableAmarilloDer_clicked
signal cableMoradoDer_clicked

# Señal cable Rojo
func _on_area_rojo_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clic detectado en calbeRojoDer")
		emit_signal("cableRojoDer_cliked")

# Señal cable Amarillo
func _on_area_amarillo_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clic detectado en calbeAmarrilloDer")
		emit_signal("cableAmarilloDer_clicked")

# Señal cable Morado
func _on_area_morado_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clic detectado en calbeAmarrilloDer")
		emit_signal("cableMoradoDer_clicked")

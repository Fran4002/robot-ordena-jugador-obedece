extends Control


func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Cables/cables-main.tscn") # Volver al primer escenario


func _on_salir_pressed() -> void:
	get_tree().quit() # Salir del juego.

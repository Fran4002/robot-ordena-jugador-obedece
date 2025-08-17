extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Games/Cables/cables-main.tscn") # Pasar a la siguiente escena.


func _on_salir_pressed() -> void:
	get_tree().quit() # Salir del juego.

extends Control

func _input(event):
	if (event is InputEventKey and event.pressed and not event.echo) or (event is InputEventMouseButton and event.pressed):
		get_tree().change_scene_to_file("res://Games/Cables/cables-main.tscn")

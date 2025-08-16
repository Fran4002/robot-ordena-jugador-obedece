extends CharacterBody2D

var speed = 800
var mouse_position = null
#hola
func _physics_process(delta: float) -> void:
	var vel = Vector2()
	mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	velocity.y = (direction * speed).y
	
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Collision")
	$"../ProgressBar"._game_over()
	pass # Replace with function body.

extends Node2D

var asteroid = preload("res://Games/Drive/asteroid.tscn")
var asteroids = []

var asteroidVelocity = Vector2(-300, 0)

func _ready() -> void:
	_on_spawn_timer_timeout()

func _process(delta: float) -> void:
	for ast in asteroids:
		ast.translate(asteroidVelocity * delta)
		pass
	var a = asteroids.front()
	if a != null and a.position.x < 0:
		asteroids.pop_front()
		remove_child(a)

func _on_spawn_timer_timeout() -> void:
	var ast = asteroid.instantiate()
	ast.scale *= 2.5
	add_child(ast)
	var screen_size = DisplayServer.window_get_size()
	var height = randi_range(40, screen_size.y - 40)
	ast.position = Vector2(screen_size.x + 40, height)
	asteroids.append(ast)
	print("Spawn Asteroid")
	pass # Replace with function body.

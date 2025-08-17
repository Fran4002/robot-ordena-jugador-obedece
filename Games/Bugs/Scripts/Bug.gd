extends CharacterBody2D  # or Area2D or whatever your enemy is

@export var move_speed := 100.0
@export var wander_radius := 150.0  # How far from origin it can move
@export var min_wander_time := 1.0
@export var max_wander_time := 3.0

var origin_position := Vector2.ZERO
var target_position := Vector2.ZERO
var timer := 0.0

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	origin_position = global_position
	pick_new_target()

func _process(delta):
	# Move toward target
	var direction = (target_position - global_position).normalized()
	var velocity = direction * move_speed
	
	# Move and slide for KinematicBody, or just move for others
	if is_instance_valid(self) and is_inside_tree():
		move_and_slide()
		global_position += velocity * delta
	
	# Check if close to target or timer expired
	if global_position.distance_to(target_position) < 5.0 or timer <= 0.0:
		pick_new_target()
	else:
		timer -= delta
		
	look_at(target_position)

func pick_new_target():
	# Get a random point within the wander radius
	var random_angle = randf() * 2 * PI
	var random_distance = randf() * wander_radius
	target_position = origin_position + Vector2(cos(random_angle), sin(random_angle)) * random_distance
	
	# Set a random time before next movement
	timer = randi_range(min_wander_time, max_wander_time)
	

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		queue_free()
		print("Enemy clicked!")
		# Add your enemy clicked logic here

func _on_mouse_entered():
	# Optional: highlight enemy when mouse hovers
	modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	# Return to normal color
	modulate = Color(1, 1, 1)

extends Pipe
# Rotation amount in degrees
const rotation_amount := 90.0

func _ready():
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	rotation_degrees += rotation_amount
	var tmp : bool
	tmp = rightConnection
	rightConnection = upConnection
	upConnection = leftConnection
	leftConnection = downConnection
	downConnection = tmp
	#debug()

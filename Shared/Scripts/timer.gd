extends ProgressBar

@export var nextScene : String = "res://Shared/end.tscn"
@export var continueOnTimeout : bool = false

var progress_bar = self
var time_remaining: float = 10.0
var max_time: float = 10.0

func _ready():
	progress_bar.max_value = max_time
	progress_bar.value = max_time

func _next_scene():
	get_tree().change_scene_to_file(nextScene)

func _game_over():
	get_tree().change_scene_to_file("res://Shared/gameover.tscn")

func _process(delta):
	time_remaining -= delta
	if time_remaining <= 0:
		if continueOnTimeout:
			_next_scene()
		else:
			_game_over()
		# Timer finished - do something here
	progress_bar.value = time_remaining

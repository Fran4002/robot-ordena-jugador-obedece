extends Control

func _straightPipe(pipe : Pipe) -> void:
	pipe._set_connections(true, true, false, false)
	pipe.debug()

func  _cornerPipe(pipe : Pipe) -> void:
	pipe._set_connections(false, true, false, true)
	pipe.debug()
	
func  _tPipe(pipe : Pipe) -> void:
	pipe._set_connections(false, true, true, true)
	pipe.debug()

func _ready() -> void:
	_straightPipe($"Pipe-9")
	
	_cornerPipe($"Pipe-1")
	_cornerPipe($"Pipe-5")
	_cornerPipe($"Pipe-6")
	_cornerPipe($"Pipe-7")
	
	_tPipe($"Pipe-8")
	_tPipe($"Pipe-4")
	_tPipe($"Pipe-3")
	_tPipe($"Pipe-2")
	
	$"Pipe-1"._set_pipes(null, $"Pipe-4", null, $"Pipe-2")
	$"Pipe-2"._set_pipes(null, $"Pipe-5", $"Pipe-1", $"Pipe-3")
	$"Pipe-3"._set_pipes(null, $"Pipe-6", $"Pipe-2", null)
	$"Pipe-4"._set_pipes($"Pipe-1", $"Pipe-7", null, $"Pipe-5")
	$"Pipe-5"._set_pipes($"Pipe-2", $"Pipe-8", $"Pipe-4", $"Pipe-6")
	$"Pipe-6"._set_pipes($"Pipe-3", $"Pipe-9", $"Pipe-5", null)
	$"Pipe-7"._set_pipes($"Pipe-4", null, null, $"Pipe-8")
	$"Pipe-8"._set_pipes($"Pipe-5", null, $"Pipe-7", $"Pipe-9")
	$"Pipe-9"._set_pipes($"Pipe-6", null, $"Pipe-8", null)

func resetPipes() -> void:
	$"Pipe-1".visited = false
	$"Pipe-2".visited = false
	$"Pipe-3".visited = false
	$"Pipe-4".visited = false
	$"Pipe-5".visited = false
	$"Pipe-6".visited = false
	$"Pipe-7".visited = false
	$"Pipe-8".visited = false
	$"Pipe-9".visited = false

func _process(delta: float) -> void:
	var queue = []
	
	resetPipes()
	
	var visited = []
	queue.append($"Pipe-Origin")
	while queue.size() != 0:
		var actual : Pipe = queue.pop_front()
		var next: Pipe
		next = actual.checkRight()
		if next != null and next.visited == false:
			next.visited = true
			queue.append(next)
		next = actual.checkLeft()
		if next != null and next.visited == false:
			next.visited = true
			queue.append(next)
		next = actual.checkUp()
		if next != null and next.visited == false:
			next.visited = true
			queue.append(next)
		next = actual.checkDown()
		if next != null and next.visited == false:
			next.visited = true
			queue.append(next)
	var end = $"Pipe-End"
	if end.checkRight() != null and $"Pipe-1".visited:
		$ProgressBar._next_scene()
		pass
	pass

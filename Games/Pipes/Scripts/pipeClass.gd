extends TextureButton
class_name Pipe

var visited = true

var upPipe = null
var downPipe = null
var leftPipe = null
var rightPipe = null 

var upConnection = false
var downConnection = false
var leftConnection = false
var rightConnection = false

func debug():
	pass
	print(self.name)
	print("Right:", rightConnection, "Left:", leftConnection, "Up:", upConnection, "Down:", downConnection)

func _set_connections(upCon : bool, downCon : bool, leftCon : bool, rightCon : bool):
	upConnection = upCon
	downConnection = downCon
	leftConnection = leftCon
	rightConnection = rightCon
	
func _set_pipes(uP : Pipe, dP: Pipe, lP: Pipe, rP: Pipe) -> void:
	upPipe = uP
	downPipe = dP
	leftPipe = lP
	rightPipe = rP

func checkRight() -> Pipe:
	if rightPipe == null or rightConnection == false:
		return null
	if rightPipe.leftConnection == false:
		return null
	return rightPipe
	
func checkLeft() -> Pipe:
	if leftPipe == null or leftConnection == false:
		return null
	if leftPipe.rightConnection == false:
		return null
	return leftPipe

func checkUp() -> Pipe:
	if upPipe == null or upConnection == false:
		return null
	if upPipe.downConnection == false:
		return null
	return upPipe
	
func checkDown() -> Pipe:
	if downPipe == null or downConnection == false:
		return null
	if downPipe.upConnection == false:
		return null
	return downPipe

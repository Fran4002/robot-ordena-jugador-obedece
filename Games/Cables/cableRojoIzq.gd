extends Node2D

var dragging := false #Para saber si estoy arrastrando
var line_created := false
@onready var line : Line2D = $Line2D #Obtengo referencia al Line2d

func _ready():
	line.clear_points() #Empieza sin puntos(nose se ve nada)

func _process(delta):
	if dragging:
		#Actualiza el segundo punto de la linea para que siga al mouse
		line.set_point_position(1, to_local(get_global_mouse_position()))
		
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Detectar clicl izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not line_created:
			#Si el mouse está dentro del area2d del cableRojoIzq
			dragging = true
			line_created = true
			line.add_point(Vector2.ZERO) #punto inicial en el cableRojoIzq
			line.add_point(to_local(get_global_mouse_position())) # punto final en el mouse


func _on_cable_rojo_der_cable_rojo_der_cliked() -> void:
	dragging = false

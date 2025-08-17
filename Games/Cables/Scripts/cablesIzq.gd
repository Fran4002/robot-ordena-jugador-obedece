extends Node2D

# var cable Rojo
var draggingR := false #Para saber si estoy arrastrando
var line_createdR := false
@onready var lineR : Line2D = $LineRojo #Obtengo referencia al Line2d

# variables cable Amarillo
var draggingA := false #Para saber si estoy arrastrando
var line_createdA := false
@onready var lineA : Line2D = $LineAmarillo #Obtengo referencia al Line2d

# variables cable Morado
var draggingM := false #Para saber si estoy arrastrando
var line_createdM := false
@onready var lineM : Line2D = $LineMorado #Obtengo referencia al Line2d


# Inicializa todas las lineas
func _ready():
	lineR.clear_points() #Empieza sin puntos(nose se ve nada)
	lineA.clear_points()
	lineM.clear_points()


# Actualiza las lineas
func _process(delta):
	if draggingR:
		#Actualiza el segundo punto de la linea para que siga al mouse
		lineR.set_point_position(1, to_local(get_global_mouse_position()))
	if draggingA:
		lineA.set_point_position(1, to_local(get_global_mouse_position()))
	if draggingM:
		lineM.set_point_position(1, to_local(get_global_mouse_position()))


# Eventos Cable Rojo
func _on_area_rojo_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Detectar clicl izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#Si el mouse está dentro del area2d del cableRojoIzq
		if event.pressed and not line_createdR and not draggingA and not draggingM:
			draggingR = true
			line_createdR = true
			lineR.add_point(to_local(get_global_mouse_position())) #punto inicial 
			lineR.add_point(to_local(get_global_mouse_position())) # punto final

func _on_cables_der_cable_rojo_der_cliked() -> void:
	draggingR = false


# Eventos Cable Amarillo
func _on_area_amarillo_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Detectar clicl izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#Si el mouse está dentro del area2d del cableRojoIzq
		if event.pressed and not line_createdA and not draggingR and not draggingM:
			draggingA = true
			line_createdA = true
			lineA.add_point(to_local(get_global_mouse_position())) #punto inicial 
			lineA.add_point(to_local(get_global_mouse_position())) # punto final

func _on_cables_der_cable_amarillo_der_clicked() -> void:
	draggingA = false


# Eventos Cable Morado
func _on_area_morado_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Detectar clicl izquierdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#Si el mouse está dentro del area2d del cableRojoIzq
		if event.pressed and not line_createdM and not draggingR and not draggingA:
			draggingM = true
			line_createdM = true
			lineM.add_point(to_local(get_global_mouse_position())) #punto inicial 
			lineM.add_point(to_local(get_global_mouse_position())) # punto final


func _on_cables_der_cable_morado_der_clicked() -> void:
	draggingM = false

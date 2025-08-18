extends Control


@onready var instrucciones: Label = $Instrucciones   # referencia al Label
@onready var secuencia_label: Label = $SecuenciaLabel
var secuencia = []       # lista que guarda la secuencia del bot
var opciones = ["Rojo", "Verde", "Azul", "Amarillo"]
var indice = 0           # en qué parte de la secuencia va el jugador
var ronda = 0
var limite_rondas = 5


func _on_rojo_pressed() -> void:
	jugador_pulsa("Rojo")

func _on_verde_pressed() -> void:
	jugador_pulsa("Verde")

func _on_amarillo_pressed() -> void:
	jugador_pulsa("Amarillo")

func _on_azul_pressed() -> void:
	jugador_pulsa("Azul")

func _ready():
	randomize()
	instrucciones.text = "Observa la secuencia..."
	nueva_ronda()

func nueva_ronda():
	ronda += 1
	if ronda > limite_rondas:
		instrucciones.text = "¡Ganaste! Completaste todas las rondas 🎉"
		return
	
	var nuevo = opciones[randi() % opciones.size()]
	secuencia.append(nuevo)
	indice = 0
	instrucciones.text = "Ronda " + str(ronda) + " - Observa la secuencia..."
	mostrar_secuencia()

func mostrar_secuencia() -> void:
	secuencia_label.text = "Secuencia: " + ", ".join(secuencia)

func jugador_pulsa(color: String):
	if color == secuencia[indice]:
		indice += 1
		if indice == secuencia.size():
			instrucciones.text = "¡Correcto! Prepárate para la siguiente ronda."
			await get_tree().create_timer(1.0).timeout
			nueva_ronda()
	else:
		instrucciones.text = "¡Fallaste! Volviendo a la ronda 1..."
		secuencia.clear()
		ronda = 0
		await get_tree().create_timer(1.0).timeout
		nueva_ronda()

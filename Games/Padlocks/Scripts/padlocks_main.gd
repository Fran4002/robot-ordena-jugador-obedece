extends Control

func _process(delta: float) -> void:
	if $Lock1.disabled == false: return
	print("Lock1 OK")
	if $Lock2.disabled == false: return
	print("Lock2 OK")
	if $Lock3.disabled == false: return
	print("Lock3 OK")
	if $Lock4.disabled == false: return
	print("Lock4 OK")
	$ProgressBar._next_scene()
	pass

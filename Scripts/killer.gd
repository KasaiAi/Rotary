extends Area3D

var danger = false

# Game over
func _on_body_entered(_body):
	danger = true
#	camada 8 é zona de risco, todas essas peças piscam em alerta

func _on_body_exited(_body):
	danger = false

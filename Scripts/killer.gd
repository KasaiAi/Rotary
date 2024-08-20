extends Area3D

var perigo = false

#game over
func _on_body_entered(_body):
	print("perigo")
	perigo = true
#	camada 8 é zona de risco, todas essas peças piscam em alerta

func _on_body_exited(_body):
	print("passou o perigo")
	perigo = false

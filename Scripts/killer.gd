extends Area3D

var danger = false

func _on_body_entered(_body):
	danger = true

func _on_body_exited(_body):
	danger = false

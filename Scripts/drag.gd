extends Node3D

var origin
var newPos
var rotating = false

func _ready():
	pass

func _process(delta):
	if rotating:
		newPos = get_viewport().get_mouse_position().x
		get_parent().rotate_y((newPos - origin) * .2 * delta)
		origin = newPos

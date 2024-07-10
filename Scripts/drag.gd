extends Node3D

@export var triggerAction:String

var origin
var newPos
var rotating = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed(triggerAction):
		origin = get_viewport().get_mouse_position().x
		rotating = true
	if Input.is_action_just_released(triggerAction):
		rotating = false
	if rotating:
		newPos = get_viewport().get_mouse_position().x
		get_parent().rotate_y((newPos - origin) * .2 * delta)
		origin = newPos

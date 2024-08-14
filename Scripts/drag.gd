extends Node3D

@export var triggerAction:String

var origin
var newPos
var rotating = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed(triggerAction):
		# Activates rotation
		origin = get_viewport().get_mouse_position().x
		rotating = true
	if Input.is_action_just_released(triggerAction):
		# Deactivates rotation
		rotating = false
		# Snaps ring rotation to fixed points
		if fposmod(get_parent().rotation_degrees.y, 18) > 9:
			get_parent().rotation_degrees.y += 18
		get_parent().rotation_degrees.y -= fposmod(get_parent().rotation_degrees.y, 18)
	if rotating:
		newPos = get_viewport().get_mouse_position().x
		get_parent().rotate_y((newPos - origin) * .2 * delta)
		origin = newPos

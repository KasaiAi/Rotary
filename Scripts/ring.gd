extends Node3D

# States
var selected = false
var dragging = false

func _on_mouse_entered():
	if not dragging:
		selected = true

func _on_mouse_exited():
	selected = false

func _process(_delta):
	# Highlights selected ring (CHANGE TRIGGER TO CELL)
	if selected:
		for i in get_children():
			if i.is_in_group("cells") and not i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = load("res://Assets/Materials/selection_highlight.tres")
		
		# Activates rotation
		if Input.is_action_just_pressed("click"):
			$dragger.process_mode = Node.PROCESS_MODE_INHERIT
#			selected = false
#			dragging = true
	else:
		for i in get_children():
			if i.is_in_group("cells") and i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = null
				
	if Input.is_action_just_released("click"):
		# Snaps ring rotation to fixed points
		if fposmod(rotation_degrees.y, 18) > 9:
			rotation_degrees.y += 18
		rotation_degrees.y -= fposmod(rotation_degrees.y, 18)
		
#		reassign array positions

#		dragging = false
#		_on_mouse_entered()

#reorganize cell array with new positions according to angle
#while rotating axis_lock_linear_y = true
#material_overlay = light white


extends Node3D

# States
var selected = false
var dragging = false

func _on_mouse_entered():
	selected = true

func _on_mouse_exited():
	selected = false

func _process(_delta):
	# Highlights selected ring (CHANGE TRIGGER TO CELL AND HIGHLIGHT ADJACENT SAME-COLOR CELLS)
	if selected:
		for i in get_children():
			if i.is_in_group("cells") and not i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = load("res://Assets/Materials/selection_highlight.tres")
		
		if Input.is_action_just_pressed("click"):
			dragging = true
	else:
		for i in get_children():
			if i.is_in_group("cells") and i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = null
				
	if Input.is_action_just_released("click"):
		dragging = false
		# Frees frozen cells
		for child in get_children():
			if child.is_in_group("cells"):
				child.freeze = false
#		reassign array positions
	
	if dragging:
		# Activates dragger node for the selected ring
		$dragger.process_mode = Node.PROCESS_MODE_INHERIT
		# Freezes cells in spinning ring so they don't shoot downwards when physics reactivate
		for child in get_children():
			if child.is_in_group("cells"):
				child.freeze = true

func _input(_event):
	if not dragging:
		# Deactivates dragger node
		$dragger.process_mode = Node.PROCESS_MODE_DISABLED

#reorganize cell array with new positions according to angle
#material_overlay = light white


extends Node3D

var selected = false

func _on_mouse_entered():
	selected = true

func _on_mouse_exited():
	selected = false

func _process(delta):
	if selected:
		for i in get_children():
			if i.is_in_group("cells") and not i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = load("res://Assets/Materials/selection_highlight.tres")
		
		if Input.is_action_just_pressed("click"):
			$dragger.process_mode = 0
		
	else:
		for i in get_children():
			if i.is_in_group("cells") and i.get_node("Mesh").material_overlay:
				i.get_node("Mesh").material_overlay = null

#cLIecK
#rOtAT e
#reorganize cell array with new positions according to angle
#while rotating axis_lock_linear_y = true
#material_overlay = light white


extends Node3D

var selected = false


func _on_area_entered():
	for i in $"Cell container".get_children():
		if i.is_in_group("cells"):
			i.get_node("Mesh").material_overlay = load("res://Assets/Materials/selection_highlight.tres")
		
func _on_area_exited():
	for i in $"Cell container".get_children():
		if i.is_in_group("cells"):
			i.get_node("Mesh").material_overlay = null


#cLIecK
#rOtAT e
#reorganize cell array with new positions according to angle
#while rotating axis_lock_linear_y = true
#material_overlay = light white

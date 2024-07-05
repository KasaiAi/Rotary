extends Node3D

func _on_area_entered():
	for i in $Cells.get_children():
		$"Cell container/Cell/RigidBody3D/Mesh".material_overlay = load("res://Assets/Materials/selection_highlight.tres")
		
func _on_area_exited():
	$"Cell container/Cell/RigidBody3D/Mesh".material_overlay = null


#cLIecK
#rOtAT e
#reorganize cell array with new positions according to angle
#while rotating axis_lock_linear_y = true
#material_overlay = light white

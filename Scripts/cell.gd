extends RigidBody3D

var cellType = randi() % 4 # Número aleatório entre 0 e 4

func _ready():
#	$RigidBody3D/Mesh.material_override = StandardMaterial3D.new() #Cria novo material pra a célula
	var material = $Mesh.get_surface_override_material(0) # Chama o material da célula
	
	match cellType: # Switch case para as quatro cores
		# O material precisa ser único, senão todos os cubos instanciados ficam da mesma cor;
		# Muda a cor (albedo) do material
		0:
			material.albedo_color = Color(0.82,0.08,0.08) # Red
		1:
			material.albedo_color = Color(0.16,0.68,0.32) # Green
		2:
			material.albedo_color = Color(0.1,0.3,0.8) # Blue
		3:
			material.albedo_color = Color(0.83,0.78,0.1) # Yellow
	
#	Pode começar com freeze = true e soltar a peça depois de 1 segundo
#	$RigidBody3D.collision_mask = grid.j #Define a camada de colisão/nível da célula de acordo com o array de peças

#flavor de destruição das peças; cria vários fragmentos que caem
func breakup():
	var smolCell = load("res://Objects/cell bit.tscn")
#	spawn 4 minicubes, not as children (particles?)
	for i in 8:
		var cellBit = smolCell.instantiate()
		cellBit.transform = transform
		cellBit.translate_object_local(Vector3(randi_range(-1, 1),1,randi_range(-1, 1)))
		cellBit.get_node("Mesh").get_surface_override_material(0).albedo_color = $Mesh.get_surface_override_material(0).albedo_color
		add_sibling(cellBit)
	queue_free()

#func _process(delta):

#	if Input.is_action_just_pressed("ui_left"):
#		reparent(get_parent().get_parent().get_node("Ring"))
#	if Input.is_action_just_pressed("ui_right"):
#		reparent(get_parent().get_parent().get_node("Ring2"))
#	print(get_parent())

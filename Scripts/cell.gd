extends Node3D

# Declare member variables here. Examples:
var cellType = randi() % 4 # Número aleatório entre 0 e 4

# Called when the node enters the scene tree for the first time.
func _ready():
#	$RigidBody3D/Mesh.material_override = StandardMaterial3D.new() #Cria novo material pra a célula
	var material = $RigidBody3D/Mesh.get_surface_override_material(0) # Chama o material da célula
	
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
	
#	$RigidBody3D.collision_mask = grid.j #Define a camada de colisão/nível da célula de acordo com o array de peças

func breakup():
	var smolCell = load("res://Objects/cell.tscn")
#	spawn 4 minicubes, not as children (particles?)
	for i in 4:
		smolCell.instantiate()
		smolCell.collision_mask = 0
		add_child(smolCell)
#	throw them up (maybe random directions)
#	queue_free()
#	if y > 680:
#		queue_free()




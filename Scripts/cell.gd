extends RigidBody3D

var cellType = randi() % 4 # Número aleatório entre 0 e 4
var onFloor = false

signal landed

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
	for i in 8:
		# Saves parent's position, applies random rotation, copies parent's color, adds minis as children of world node and deletes parent cell
		var cellBit = smolCell.instantiate()
		cellBit.transform = global_transform
		cellBit.translate_object_local(Vector3(randi_range(-1, 1),1,randi_range(-1, 1)))
		cellBit.get_node("Mesh").get_surface_override_material(0).albedo_color = $Mesh.get_surface_override_material(0).albedo_color
		get_tree().root.get_child(0).add_child(cellBit)
	queue_free()

func on_landing():
	if linear_velocity.y < -1:
		onFloor = false
	if not onFloor and $Grounded.is_colliding():
		onFloor = true
		emit_signal("landed", self)

func _physics_process(_delta):
		on_landing()

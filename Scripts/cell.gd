extends RigidBody3D

const GRAVITY = .01
var speed = 0

var cellType = randi() % 4 # Número aleatório entre 0 e 4
var onFloor = false

signal falling
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
	
	Global.connect("unfreeze", _unfreeze)
#	$RigidBody3D.collision_mask = grid.j #Define a camada de colisão/nível da célula de acordo com o array de peças

func _drop_timeout():
	_unfreeze()

func _unfreeze():
	freeze = false

#func _on_mouse_entered():
#	print("a")
#	$Mesh.material_overlay = load("res://Assets/Materials/selection_highlight.tres")
#
#func _on_mouse_exited():
#	print("b")
#	$Mesh.material_overlay = null

# Flavor de destruição das peças; cria vários fragmentos que caem
func breakup():
	Global.emit_signal("unfreeze")
	var smolCell = load("res://Objects/cell bit.tscn")
	for i in 8:
		# Saves parent's position, applies random rotation, copies parent's color, adds minis as children of world node and deletes parent cell
		var cellBit = smolCell.instantiate()
		cellBit.transform = global_transform
		cellBit.translate_object_local(Vector3(randi_range(-1, 1),1,randi_range(-1, 1)))
		cellBit.get_node("Mesh").get_surface_override_material(0).albedo_color = $Mesh.get_surface_override_material(0).albedo_color
		get_tree().root.get_child(0).add_child(cellBit)
	queue_free()

#func _process(_delta):
#	if not onFloor and $Grounded.is_colliding():
#		print($Grounded.get_collider())
#	if not $Grounded.is_colliding():
#		print("caiu")
#	else:
#		print("fixou")

# StaticBody
#func _physics_process(_delta):
#	if not onFloor and $Grounded.is_colliding():
#		speed = 0
#		onFloor = true
#		print("colidiu")
#	elif not $Grounded.is_colliding():
#		onFloor = false
#		speed -= GRAVITY
#		translate(Vector3(0, speed, 0))

# RigidBody
func _physics_process(_delta):
	if linear_velocity.y < -2:
		onFloor = false
		emit_signal("falling", self)
	if not onFloor and $Grounded.is_colliding():
		onFloor = true
		freeze = true
		emit_signal("landed", self)
		print(global_position.y)
		linear_velocity.y = 0

extends RigidBody3D

var cellType = randi() % 4 # Número aleatório entre 0 e 4
var onFloor = false
var checked = false

var level # Numerical value for the cell's vertical level
var truePosition # Adjusted array position

signal falling
signal landed
signal clear

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
	
	Global.connect("wake_up", _wake_up)

func _drop_timeout():
	_wake_up()

func _wake_up():
	freeze = false

#func _on_mouse_entered():
#	if $Mesh.material_overlay:
#		$Mesh.material_overlay = null
#		remove_from_group("checked")
#	else:
#		$Mesh.material_overlay = load("res://Assets/Materials/selection_highlight.tres")
#	neighborCheck()
#	print("a")
#	$Mesh.material_overlay = load("res://Assets/Materials/selection_highlight.tres")
#
#func _on_mouse_exited():
#	print("b")
#	$Mesh.material_overlay = null

# Flavor de destruição das peças; cria vários fragmentos que caem
func breakup():
	Global.emit_signal("wake_up")
	var smolCell = load("res://Objects/cell bit.tscn")
	for i in 8:
		# Copia a posição do pai, define uma rotação aleatória, copia a cor do pai, adiciona minis
		# como filhas do nó raiz e deleta a peça original
		var cellBit = smolCell.instantiate()
		cellBit.transform = $Mesh.global_transform
		cellBit.translate_object_local(Vector3(randi_range(-1, 1),1,randi_range(-1, 1)))
		cellBit.get_node("Mesh").get_surface_override_material(0).albedo_color = $Mesh.get_surface_override_material(0).albedo_color
		get_tree().root.get_child(0).add_child(cellBit)
	queue_free()

# Checa se as peças adjacentes são da mesma cor
func neighborCheck():
	probe($Above.get_collider())
	probe($Below.get_collider())
	probe($Right.get_collider())
	probe($Left.get_collider())

# Função assistente pra reduzir a neighborCheck()
func probe(neighbor):
	if neighbor != null and neighbor.name != "Floor":
		if neighbor.is_in_group("cells") and neighbor.cellType == cellType:
			print("Match!")
			checked = true
			if not neighbor.checked:
				neighbor.neighborCheck()
			breakup()

func _physics_process(_delta):
	if onFloor and linear_velocity.y < -2:
		onFloor = false
		emit_signal("falling", self)
		emit_signal("clear", self)
	if not onFloor and $Grounded.is_colliding():
		onFloor = true
		emit_signal("landed", self)
		linear_velocity.y = 0
	if $Grounded.get_collider() != null and $Grounded.get_collider().onFloor == false:
		onFloor = false

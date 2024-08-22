extends RigidBody3D

var cellType = randi() % 4 # Número aleatório entre 0 e 4
var onFloor = false # Is touches florr?
var checked = false # To avoid endless recursion during contiguousCheck()
var clipping = false # Tells if there is another cell in this space

var level # Numerical value for the cell's vertical level

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
	
	Global.connect("wake_up", _wake_up)
	Global.connect("release", _release)

func _drop_timeout():
	_wake_up()

func _wake_up():
	freeze = false

# Break or resets cells when clicked
func _release():
	if is_in_group("checked"):
		if Global.matchCount >= 4:
			breakup()
		else:
			remove_from_group("checked")

#func _on_mouse_entered():
#	if $Mesh.material_overlay:
#		$Mesh.material_overlay = null
#		remove_from_group("checked")
#	else:
#		$Mesh.material_overlay = load("res://Assets/Materials/selection_highlight.tres")
#	contiguousCheck()
#	print("a")
#	$Mesh.material_overlay = load("res://Assets/Materials/selection_highlight.tres")
#
#func _on_mouse_exited():
#	print("b")
#	$Mesh.material_overlay = null

# Cell destruction flavor; creates multiple falling fragments
func breakup():
	Global.emit_signal("wake_up")
	var smolCell = load("res://Objects/cell bit.tscn")
	for i in 8:
		# Copies parent position, assign random rotation, copies parent's color, adds minis as children of
		# root node and deletes the cell
		var cellBit = smolCell.instantiate()
		cellBit.transform = $Mesh.global_transform
		cellBit.translate_object_local(Vector3(randi_range(-1, 1),1,randi_range(-1, 1)))
		cellBit.get_node("Mesh").get_surface_override_material(0).albedo_color = $Mesh.get_surface_override_material(0).albedo_color
		get_tree().root.get_child(0).add_child(cellBit)
	queue_free()

# Checks if adjacent cells are the same color
func contiguousCheck():
	Global.matchCount += 1
	probe($Above.get_collider())
	probe($Below.get_collider())
	probe($Right.get_collider())
	probe($Left.get_collider())

# Assistant function to clean up contiguousCheck()
func probe(neighbor):
	if neighbor != null and neighbor.name != "Floor":
		if neighbor.is_in_group("cells") and neighbor.cellType == cellType:
			add_to_group("checked")
			if not neighbor.is_in_group("checked"):
				neighbor.contiguousCheck()

func _physics_process(_delta):
	# Conditions for managing falling and landing
	if onFloor and linear_velocity.y < -2:
		onFloor = false
		emit_signal("falling", self)
	if not onFloor and $Grounded.is_colliding():
		onFloor = true
		emit_signal("landed", self)
		linear_velocity.y = 0
	if $Grounded.get_collider() != null and $Grounded.get_collider().onFloor == false:
		onFloor = false

# Clipping treatment; still needs work
func _on_clip(body):
	if body != self and body.is_in_group("cells") and not onFloor:
		clipping = true
		queue_free() # Temporary clipping fix, ideally the cell should fall in the correct spot

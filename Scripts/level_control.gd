extends Node3D

# Grid and array variables
@export var maxRings = 8	# Height
@export var ringSize = 20	# Width
#var grid:Array
#var ringPosition = [Vector3(0, 0, 5.25),
# Vector3(1.62, 0, 4.99),
# Vector3(3.08, 0, 4.24),
# Vector3(4.24, 0, 3.08),
# Vector3(4.99, 0, 1.62),
# Vector3(5.25, 0, -0),
# Vector3(4.99, 0, -1.62),
# Vector3(4.24, 0, -3.08),
# Vector3(3.08, 0, -4.24),
# Vector3(1.62, 0, -4.99),
# Vector3(0, 0, -5.25),
# Vector3(-1.62, 0, -4.99),
# Vector3(-3.08, 0, -4.24),
# Vector3(-4.24, 0, -3.08),
# Vector3(-4.99, 0, -1.62),
# Vector3(-5.25, 0, 0),
# Vector3(-4.99, 0, 1.62),
# Vector3(-4.24, 0, 3.08),
# Vector3(-3.08, 0, 4.24),
# Vector3(-1.62, 0, 4.99)]
#var ringRotation = [0,
# 0.31,
# 0.63,
# 0.94,
# 1.25,
# 1.57,
# 1.88,
# 2.2,
# 2.51,
# 2.82,
# 3.14,
# -2.82,
# -2.51,
# -2.2,
# -1.88,
# -1.57,
# -1.25,
# -0.94,
# -0.63,
# -0.31]

# Raycast variables
var mousePos
var rayOrigin
var rayEnd

# Cell creation variables
var cellObject = load("res://Objects/cell.tscn")
var cellType

func _ready():
	randomize()
#	grid = create_array()
#	print(grid)
	
	startup(0)

#func create_array():
#	var array = []
#	for i in maxRings:
#		array.append([])
#		for j in ringSize:
#			array[i].append(null)
#	return array

func startup(initialSpawn):#initialSpawn
	if initialSpawn > 0:
		$SpawnTimer.start(0.03)
		await $SpawnTimer.timeout
		initialSpawn -= 1
		startup(initialSpawn)
	if initialSpawn <= 0:
#		$SpawnTimer.start(.7)
		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
#	await get_tree().create_timer(1).timeout
	spawn_cell()

func spawn_cell(amount:int = 1):
	if $Spawner/Killer.perigo == true:
		get_tree().paused = true
		$Gameover.visible = true
	for i in amount:
		var newCell = cellObject.instantiate()
		newCell.transform = $Spawner.global_transform
		
		newCell.connect("landed", _on_cell_landed)
		newCell.connect("falling", _on_cell_falling)
		add_child(newCell)
		move_spawn_point()

func spawn_ring():
	spawn_cell(19)
	Global.emit_signal("wake_up")

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),PI/10)

func _on_cell_falling(cell):
	cell.reparent(self)

# Set cell level according to height in world
func _on_cell_landed(cell):
	cell.level = roundi(cell.global_position.y/2)
	var layer # Temp variable for the cell's ring node
#	print("Landed! Layer ",level)
	
	match cell.level:
		8:
			print("perigo")
		7:
			layer = $Cylinder/Level8
		6:
			layer = $Cylinder/Level7
		5:
			layer = $Cylinder/Level6
		4:
			layer = $Cylinder/Level5
		3:
			layer = $Cylinder/Level4
		2:
			layer = $Cylinder/Level3
		1:
			layer = $Cylinder/Level2
		0:
			layer = $Cylinder/Level1
	
	if layer is Object:
		#  Change parent, keep global transform
		cell.reparent(layer, true)
		# Freeze physics to reduce jitter
		if cell.global_position.y == cell.level*2:
			cell.freeze = true
		# Fix cell rotation upon reparenting
		cell.rotation.y = snappedf(cell.rotation.y, PI/10)
		# Fix coordinates for the grid array
		cell.truePosition = roundi(cell.rotation.y/(PI/10))
		if cell.truePosition < 0:
			cell.truePosition += 20
		
#		print(cell.level,", ",cell.truePosition)
		
		# Append cell to array
#		grid[cell.level][cell.truePosition] = cell.cellType
		
#		print(grid[0])
#		print(grid[1])
#		print()

#func _on_cell_clear(cell):
#	cell.level = roundi(cell.global_position.y/2)
#	cell.truePosition = roundi(cell.rotation.y/(PI/10))
#	grid[cell.level][cell.truePosition] = null
#	print(grid[0])
#	print(grid[1])
#	print()

#func _process(_delta):
#	mousePos = get_viewport().get_mouse_position()
#	$Mouseover.target_position = Vector3((mousePos.x-300)/40, (-mousePos.y+324)/40, -15)

func _input(_event):
	var object = raycast_object()
	if Input.is_action_just_pressed("ui_select"):
		spawn_ring()
	if Input.is_action_just_pressed("ui_down"):
		spawn_cell()
	if Input.is_action_just_pressed("ui_left"):
		$Spawner.rotate(Vector3(0,1,0),-PI/10)
	if Input.is_action_just_pressed("ui_right"):
		move_spawn_point()
	if Input.is_action_just_released("click"):
		if object != null and object.is_in_group("cells"):
#			object.breakup()
			object.neighborCheck()
#		spawn_cell()

# Raycaster
func raycast_object():
	var spaceState = get_world_3d().direct_space_state
	mousePos = get_viewport().get_mouse_position()
	var camera = $Camera3D
	
	rayOrigin = camera.project_ray_origin(mousePos)
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 200
	
	var intersect = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
#	intersect.collide_with_areas = true
	var ray = spaceState.intersect_ray(intersect)
	
	if ray.has("collider"):
		return ray.collider

func _on_retry_button_up():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
	get_tree().paused = false


#Criar peça no cenário									OK!
#Criar peça colorida no cenário							OK!
#Criar anel												OK!
#Criar anel com cores aleatórias						OK!
#Adicionar rigidbody, peso e chão						OK!
#Travar queda das peças no eixo Y						OK!
#Fazer com que as peças não quiquem						OK!
#Fazer com que peças formem um cilindro					OK!
#Organizar criação de peça em uma função				OK!
#Upgrade pra 4.1										OK!
#Segmentar funções melhor								OK!
#Não dá pra diferenciar as peças de trás das da frente	OK!
#Ajeitar a função do timer								OK!
#Separar spawn inicial do spawn constante				OK!
#Mover script de spawn pra o spawner					OK!
#Melhorar a posição de spawn							OK!
#Mudei a hierarquia de do cubo							OK!
#Criar objeto Ring com caixa de colisão					OK!
#Peças quebram em pedacinhos que caem					OK!
#Deletar destroços que saem da tela						OK!
#Deixar a cor dos minicubos igual ao original			OK!
#Girar anel com o mouse									OK!
#Girar cilindro com o mouse								OK!
#Iluminar objetos com hover								OK!
#Apagar objetos sem hover								OK!
#Criar cubinhos como filhos do mundo					OK!
#Fazer a função startup funcionar como eu quero			OK!
#Tornar peça filha do anel onde aterrissar				OK!
#Rotacionar anel c/ snapping							OK!
#Consertar posicionamento da peça quando entra no anel	OK!
#Mover aneis independentemente							OK!
#Fazer algo quando peças chegarem no topo				OK!
#Melhorar a interação do killer							OK!
#Placeholder do game over								OK!
#Fazer a rotação do cilindro travar também				OK!
#Peças visíveis no topo antes de cair (timer local)		OK!
#Peças mais de cima não estão caindo					OK!

#Destruição de peças iguais adjacentes					OK!
#Adicionar peças criadas num array						FDS EU VENCI AHAHAHAHAH
#Atualizar o grid após alteração das peças				NUNCAAA AAHAHAHA
#Mudar método da rotação pra colidir com os cubos		
#Consertar peças caindo dentro de outras				
#Criar condição pra não destruir depois de arrastar		

#Melhorar as cores
#Tentar embaralhar mais as peças?

## Bugs nó-cego
#Consertar o bug do cubo extra no cell.tscn				OK!
#Peças não se movem quando as de baixo somem			OK!
#Peças flutuantes disparam quando soltas				OK!
#Raycast é bloqueado pelos colisores dos anéis			OK!
#Sinal de aterrissagem tá duplicado sem motivo			OK!
#Peças tremem quando estão paradas						OK!
#Com freeze ou sem freeze?								OK!
#Consertar rotação da peça quando entra no anel			OK!
#Consertar iluminação									

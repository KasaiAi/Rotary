extends Node3D

# Grid and array variables
@export var maxRings = 8	# Height
@export var ringSize = 20	# Width
var grid:Array
var ringPosition = [Vector3(0, 0, 5.25),
Vector3(1.62, 0, 4.99),
Vector3(3.08, 0, 4.24),
Vector3(4.24, 0, 3.08),
Vector3(4.99, 0, 1.62),
Vector3(5.25, 0, -0),
Vector3(4.99, 0, -1.62),
Vector3(4.24, 0, -3.08),
Vector3(3.08, 0, -4.24),
Vector3(1.62, 0, -4.99),
Vector3(0, 0, -5.25),
Vector3(-1.62, 0, -4.99),
Vector3(-3.08, 0, -4.24),
Vector3(-4.24, 0, -3.08),
Vector3(-4.99, 0, -1.62),
Vector3(-5.25, 0, 0),
Vector3(-4.99, 0, 1.62),
Vector3(-4.24, 0, 3.08),
Vector3(-3.08, 0, 4.24),
Vector3(-1.62, 0, 4.99)]
var ringRotation = [0, 0.31, 0.63, 0.94, 1.25, 1.57, 1.88, 2.2, 2.51, 2.82, 3.14, -2.82, -2.51, -2.2, -1.88, -1.57, -1.25, -0.94, -0.63, -0.31]

# Raycast variables
var mousePos
var rayOrigin
var rayEnd

# Cell creation variables
var cellObject = load("res://Objects/cell.tscn")
var cellType

func _ready():
	randomize()
	grid = create_array()
#	print(grid)
	
	startup(0)

func create_array():
	var array = []
	for i in ringSize:
		array.append([])
		for j in maxRings:
			array[i].append(null)
	return array

func startup(initialSpawn):#initialSpawn
	if initialSpawn > 0:
		$SpawnTimer.start(0.03)
		await $SpawnTimer.timeout
		initialSpawn -= 1
		startup(initialSpawn)
	if initialSpawn <= 0:
		$SpawnTimer.start(.7)
		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
#	await get_tree().create_timer(1).timeout
	spawn_cell()

func spawn_cell(amount:int = 1):
	if $Spawner/Killer.perigo == true:
		get_tree().paused = true
		$Control.visible = true
#		gameover message and retry
	for i in amount:
		var newCell = cellObject.instantiate()
		newCell.transform = $Spawner.global_transform
		newCell.translate_object_local(Vector3(0,0,5.25))
		
#		addCellToArray(newCell)
		newCell.connect("landed", _on_cell_landing)
		add_child(newCell)
		move_spawn_point()

func addCellToArray(newCell):
	for width in ringSize:
		for height in maxRings:
			if grid[width][height] == null:
				grid[width][height] = newCell
				print(grid)
				return

# Set cell level according to height in world
func _on_cell_landing(cell):
#	for child in $Cylinder.get_children():
#		for grandchild in child.get_children():
#			if grandchild.is_in_group("cells"):
#				grandchild.sleeping = false
	
	var level = roundi(cell.global_position.y/2)
#	print("Landed! Layer ",level)
	
	match level:
		8:
			print("perigo")
		7:
			level = $Cylinder/Level8
		6:
			level = $Cylinder/Level7
		5:
			level = $Cylinder/Level6
		4:
			level = $Cylinder/Level5
		3:
			level = $Cylinder/Level4
		2:
			level = $Cylinder/Level3
		1:
			level = $Cylinder/Level2
		0:
			level = $Cylinder/Level1
	
	if level is Object:
		#  Change parent, keep global position
		cell.reparent(level, true)
#		print(cell.global_rotation.y)
		
		# Fix cell position upon reparenting
		var closest = 10
		var newPos
		for i in (ringPosition):
			if cell.position.distance_to(i) < closest:
				closest = cell.position.distance_to(i)
				newPos = i
		cell.position = newPos
		
		# Fix cell rotation upon reparenting (broken)
#		var diff = fmod(cell.global_rotation.y, PI/10)
#		if cell.global_rotation.y > 0:
#			cell.global_rotation.y -= diff
#		else:
#			cell.global_rotation.y += diff
	
#	upon landing, append cell to array

func spawn_ring():
	spawn_cell(20)

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),PI/10)

func _process(_delta):
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
			object.breakup()
		spawn_cell()
	
#	print(object)
#	print(raycast_object())
#	if Input.is_action_just_pressed("drag"):
#		spin()
	
#	mousePos = get_viewport().get_mouse_position()
#	$Mouseover.target_position = Vector3((mousePos.x-300)/40, (-mousePos.y+324)/40, -15)
	
#	highlight the collider's entire row

#raycaster
func raycast_object():
	var spaceState = get_world_3d().direct_space_state
	mousePos = get_viewport().get_mouse_position()
	var camera = $Camera3D
	
	rayOrigin = camera.project_ray_origin(mousePos)
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 200
	
	var intersect = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	intersect.collide_with_areas = true
	var ray = spaceState.intersect_ray(intersect)
	
	if ray.has("collider"):
		return ray.collider


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

#Mudar método da rotação pra colisão com os cubos		
#Fazer a rotação do cilindro travar também				
#Adicionar peças criadas num array						
#Destruição de peças iguais adjacentes					
#Atualizar o grid após movimentação, quebra e queda das peças
#Placeholder do game over								
#Peças visíveis no topo antes de cair (timer próprio)	

#Máquina de estados pros cubos ou anéis...

#Melhorar as cores
#Tentar embaralhar mais as peças?

## Bugs nó-cego
#Consertar o bug do cubo extra no cell.tscn			OK!
#Peças não se movem quando as de baixo somem		OK!
#Raycast é bloqueado pelos colisores dos anéis		
#Consertar iluminação
#Sinal de aterrissagem tá duplicado sem motivo		
#Consertar rotação da peça quando entra no anel		
#Peças flutuantes disparam quando soltas			

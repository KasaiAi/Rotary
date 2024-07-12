extends Node3D

@export var maxRings = 8
@export var ringSize = 20
var grid:Array

var raycastTarget
var mousePos
var rayOrigin
var rayEnd

var cellObject = load("res://Objects/cell.tscn")
var cellType
#var cellID

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

func _on_cell_landing(cell):
	var level = roundi(cell.global_position.y/2)+1
	print("layer ", level)
#
#	match level:
#		8:
#			print("layer 8")
#		7:
#			print("layer 7")
#		6:
#			print("layer 6")
#		5:
#			print("layer 5")
#		4:
#			print("layer 4")
#		3:
#			print("layer 3")
#		2:
#			print("layer 2")
#		1:
#			print("layer 1")

#	upon landing, append cell to array
#	set cell as child of a ring by level -> match position.y < X > position.y: remove_child(), add_child()
#	set collision_mask to array.j

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

#game over
func _on_killer_body_entered(_body):
	print("perigo")
#	camada 9 é zona de risco, todas essas peças piscam em alerta
#	if perigo and spawn_cell():
#		game over
#	get_tree().paused = true
#	screen fade
#	gameover message and retry

#Criar peça no cenário						OK!
#Criar peça colorida no cenário				OK!
#Criar anel									OK!
#Criar anel com cores aleatórias			OK!
#Adicionar rigidbody, peso e chão			OK!
#Travar queda das peças no eixo Y			OK?
#Fazer com que as peças não quiquem			OK!
#Fazer com que peças formem um cilindro		OK!
#Organizar criação de peça em uma função	OK!
#Upgrade pra 4.1							OK!
#Segmentar funções melhor					OK!
#Não dá pra diferenciar as peças de trás das da frente	OK!
#Ajeitar a função do timer					OK!
#Separar spawn inicial do spawn constante	OK!
#Mover script de spawn pra o spawner		OK!
#Melhorar a posição de spawn				OK!
#Mudei a hierarquia de do cubo				OK!
#Criar objeto Ring com caixa de colisão		OK!
#Peças quebram em pedacinhos que caem		OK!
#Deletar destroços que saem da tela			OK!
#Deixar a cor dos minicubos igual ao original	OK!
#Girar anel com o mouse						OK!
#Girar cilindro com o mouse					OK!
#Iluminar objetos com hover					OK!
#Apagar objetos sem hover					OK!
#Criar cubinhos como filhos do mundo		OK!
#Fazer a função startup funcionar como eu quero	OK!

#Adicionar peças criadas num array			OK?
#Tornar peça filha do anel onde aterrissar
#Rotacionar anel c/ snapping


#Fazer algo quando peças chegarem no topo	
#	Spawn segura as peças até formar um anel ou solta uma por uma? Crucial pro fim de jogo
#	Prefiro soltar uma por uma, dá mais tempo de tensão

#Destruição de peças iguais adjacentes

#fragmentos têm que ser removidos da árvore pra não serem afetados pela rotação
#a física travar durante a rotação pode ser genial pra os cubos não caírem antes de você soltar o mouse (o problema é que eles caem com força depois)
#cubos têm que entrar no array/virar filhos quando aterrissarem, senão eles são afetados pela rotação enquanto caem

#Organizar peças por nível e como fazer elas quebrarem
#	um array deve facilitar pra comparar as peças próximas
#	estratificar pela altura deve facilitar pra determinar em qual anel a peça está
#	talvez um misto?
#	setar a collision_mask de acordo com a dimensão j do objeto

#Tem que clicar pra quebrar as peças
#	se for automático vai ficar uma bagunça
#	clicar e segurar move o anel, clique rápido quebra peças semelhantes
#	depois da primeira quebra dá pra combar
#Atualizar o grid após mover as peças

#Melhorar a interação do killer

#Melhorar as cores
#Tentar embaralhar mais as peças?

#Consertar o bug do cubo extra no cell.tscn	OK!
#Impedir que peças em queda empurrem as de baixo
#Às vezes peças congelam quando as de baixo são deletadas
#Raycast é bloqueado pelos colisores dos anéis
#Consertar iluminação

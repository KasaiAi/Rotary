extends Node3D

@export var maxRings = 8
@export var ringSize = 20
@export var initialSpawn = 100
var grid:Array

var raycastTarget
var mousePos
var rayOrigin
var rayEnd

var cell = load("res://Objects/cell.tscn")
var cellType
#var cellID

func _ready():
	randomize()
	grid = make_2d_array()
	
	$SpawnTimer.start(0.03)

func make_2d_array():
	var array = []
	for i in ringSize:
		array.append([])
		for j in maxRings:
			array[i].append(null)
	return array

func startup():
	if initialSpawn > 0:
		initialSpawn -= 1
		$SpawnTimer.start(.03)
	if initialSpawn <= 0:
		$SpawnTimer.start(.7)
		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
	spawn_cell()
	move_spawn_point()
	startup() #Ineficiente, queria fazer o spawn inicial de X peças e depois esquecer essa função
#	gameover() 

func spawn_cell():
	var newCell = cell.instantiate()
	newCell.transform = $Spawner.transform
	newCell.translate_object_local(Vector3(0,0,5.25))
	
	$Cylinder/Ring.add_child(newCell)
#	append cell to array
#	set cell as child of a ring by level -> match position.y < X > position.y: remove_child(), add_child()
#	set collision_mask to array.j

func spawn_ring():
	for i in 20:
		spawn_cell()
		move_spawn_point()

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),PI/10)
#	if collide with cell:
#		game over

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
		move_spawn_point()
	
#	print(object)
#	print(raycast_object())
#	if Input.is_action_just_pressed("drag"):
#		spin()
	
#	mousePos = get_viewport().get_mouse_position()
#	$Mouseover.target_position = Vector3((mousePos.x-300)/40, (-mousePos.y+324)/40, -15)
	
#	highlight the collider

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

func drag():
	var origin = mousePos.x
	

#game over
func _on_killer_body_entered(_body):
	print("perdeu")

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
#Girar anel com o mouse
#Girar cilindro com o mouse
#Rotacionar anel c/ snapping
#Iluminar objetos com hover
#Apagar objetos sem hover

#Colocar peça como child do anel pela altura

#Fazer algo quando peças chegarem no topo	
#	Spawn segura as peças até formar um anel ou solta uma por uma? Crucial pro fim de jogo
#	Prefiro soltar uma por uma, dá mais tempo de tensão

#Destruição de peças iguais adjacentes

#Fazer um array que adicione as peças criadas

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

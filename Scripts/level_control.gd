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
	startup()

func spawn_cell():
	var newCell = cell.instantiate()
	newCell.position = $Spawner.position
	newCell.rotation = $Spawner.rotation
	add_child(newCell)
#	append cell to array
#	set collision_mask to array.j

func spawn_ring():
	for i in 20:
		spawn_cell()
		move_spawn_point()

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),PI/10)
	print($Spawner.rotation.y)
#	if collide with cell:
#		game over

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		spawn_ring()
	if Input.is_action_just_released("click"):
		spawn_cell()
		move_spawn_point()
	if Input.is_action_pressed("click"):
		raycast_object()
	if Input.is_action_just_released("drag"):
		move_spawn_point()
	
	mousePos = get_viewport().get_mouse_position()
	$Mouseover.target_position = Vector3((mousePos.x-300)/40, (-mousePos.y+324)/40, -15)
	
#	highlight the collider

func raycast_object():
	var spaceState = get_world_3d().direct_space_state
	mousePos = get_viewport().get_mouse_position()
	var camera = $Camera3D
	
	rayOrigin = camera.project_ray_origin(mousePos)
#	try a fixed origin, far from the target
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 200
	
	var intersect = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var ray = spaceState.intersect_ray(intersect)
	
	if ray.has("collider"):
#		return ray.collider.get_parent()
		ray.collider.get_parent().free()

#Criar peça no cenário						OK!
#Criar peça colorida no cenário				OK!
#Criar anel									OK!
#Criar anel com cores aleatórias			OK!
#Adicionar rigidbody, peso e chão			OK!
#Travar queda das peças no eixo Y			OK?
#Fazer com que as peças não quiquem			OK!
#Fazer com que peças formem um cilindro		OK!
#Upgrade pra 4.1							OK!
#Segmentar funções melhor					OK!
#Ajeitar a função do timer					OK!
#Separar spawn inicial do spawn constante	OK!

#Fazer algo quando peças chegarem no topo	
#	Spawn segura as peças até formar um anel ou solta uma por uma? Crucial pro fim de jogo

#drag
#destroy
#cylinder turn
#Rotacionar anel c/ snapping

#Fazer um array que adicione as peças criadas
#Colocar peça como child do anel de acordo com a altura

#Organizar peças por nível e como fazer elas quebrarem
#	um array deve facilitar pra comparar as peças próximas
#	estratificar pela altura deve facilitar pra determinar em qual anel a peça está
#	talvez um misto?
#	setar a collision_mask de acordo com a dimensão j do objeto

#Tem que clicar pra quebrar as peças
#	se for automático vai ficar uma bagunça
#	clicar e segurar move o anel, clique rápido quebra peças semelhantes
#	depois da primeira quebra dá pra combar

#Peças quebram em 4 pedacinhos que caem
#Deletar destroços que saem da tela
#Quando peças são quebradas ou movidas as de cima podem cair
#Inserir anel de peças novas após algum tempo
#Rotacionar câmera em um eixo (full cylinder node)

#Organizar criação de peça em uma função	OK!
#Consertar o bug do cubo extra no cell.tscn	OK!
#Impedir que peças em queda empurrem as de baixo
#Melhorar as cores
#Tentar embaralhar mais as peças
#Não dá pra diferenciar as peças de trás das da frente

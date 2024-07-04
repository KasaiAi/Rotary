extends Node3D

@export var maxRings = 8
@export var ringSize = 20
@export var spawnRotationAngle= 0.314159
@export var ringOffset = 5
@export var initialSpawn = 7
@export var spawnCD = 0.03
var all_pieces:Array

var raycastTarget
var mousePos
var rayOrigin
var rayEnd

var cell = load("res://Objects/cell.tscn")
var cellType
var spawnTimer = Timer.new()

func _ready():
	randomize()
	all_pieces = make_2d_array()
	
	#conectar esse sinal direito
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	
	spawnTimer.start(spawnCD)

func make_2d_array():
	var array = []
	for i in ringSize:
		array.append([])
		for j in maxRings:
			array[i].append(null)
	return array

func _on_spawnTimer_timeout():
	spawn_cell()
	move_spawn_point()
	if initialSpawn > 0:
		initialSpawn -= 1
	if initialSpawn <= 0:
		spawnCD = .7
		spawnTimer.start(spawnCD)
		spawnTimer.stop()

func spawn_cell():
	var newCell = cell.instantiate()
	newCell.position = $Spawner.position
	newCell.rotation = $Spawner.rotation
	add_child(newCell)
#on spawn, add cell to array
#your array position wil determine your height position

func spawn_ring():
	for i in 20:
		spawn_cell()
		move_spawn_point()

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),spawnRotationAngle)
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

	print(mousePos)
	print($Mouseover.target_position)
	
#	highlight the collider

func raycast_object():
	var spaceState = get_world_3d().get_direct_space_state()
	mousePos = get_viewport().get_mouse_position()
	var camera = $Camera3D
	
	rayOrigin = camera.project_ray_origin(mousePos)
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

#Fazer algo quando peças chegarem no topo	
#	Spawn segura as peças até formar um anel ou solta uma por uma? Crucial pro fim de jogo

#Ajeitar a função do timer
#Usar o node no lugar do código puro?
#Separar spawn inicial do spawn constante

#Rotacionar anel (rotate object, snap)

#Fazer um array que adicione as peças criadas
#Colocar peça como child do anel de acordo com a altura

#Organizar peças por nível e como fazer elas quebrarem
#	um array deve facilitar pra comparar as peças próximas
#	estratificar pela altura deve facilitar pra determinar em qual anel a peça está
#	talvez um misto?

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

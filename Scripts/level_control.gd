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
	
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout")) #
	add_child(spawnTimer)
	
	spawnTimer.start(spawnCD)

func make_2d_array():
	var array = []
	for i in ringSize:
		array.append([])
		for j in maxRings:
			array[i].append(null)
	return array

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),spawnRotationAngle)

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

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		spawn_ring()
	if Input.is_action_just_released("click"):
		spawn_cell()
		move_spawn_point()
	if Input.is_action_just_released("drag"):
		move_spawn_point()
	
	print(raycast_object())

	mousePos = get_viewport().get_mouse_position()
	$Mouseover.target_position = Vector3((mousePos.x-300)/40, (-mousePos.y+324)/40, -15)

	print(mousePos)
	print($Mouseover.target_position)
	
#	highlight the hit object

func raycast_object():
	var spaceState = get_world_3d().get_direct_space_state()
	
	mousePos = get_viewport().get_mouse_position()
	var camera = $Camera3D
	
	rayOrigin = camera.project_ray_origin(mousePos)
	rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 20
	var intersect = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var ray = spaceState.intersect_ray(intersect)
	if ray:
		return ray.collider
	return Vector3()
	

func _on_spawnTimer_timeout():
	spawn_cell()
	move_spawn_point()
	if initialSpawn > 0:
		initialSpawn -= 1
	if initialSpawn <= 0:
		spawnCD = .7
		spawnTimer.start(spawnCD)
#		spawnTimer.stop()

#Criar peça no cenário						OK!
#Criar peça colorida no cenário				OK!
#Criar anel									OK!
#Criar anel com cores aleatórias			OK!
#Adicionar rigidbody, peso e chão			OK!
#Adicionar zona limite pra peças (teto)		
#Travar queda das peças no eixo Y			OK?
#Fazer com que as peças não quiquem			OK!
#Fazer com que peças formem um cilindro		OK!
#Separar spawn inicial do timer constante
#Criar peça como child do anel mais baixo
#RAYCAST
#Rotacionar anel (rotate object, snap)		
#Deletar peças que combinem (quando soltar mouse e 4+ peças se alinharem)
#Peças quebram em 4 pedacinhos que caem	
#Deletar destroços que saem da tela		
#Quando peças são quebradas as de cima caem	
#Quebrar apenas peças visíveis				
#Inserir anel de peças novas após algum tempo
#Rotacionar câmera em um eixo (full cylinder node)

#Organizar criação de peça em uma função
#Consertar o bug do cubo extra no cell.tscn
#Impedir que peças em queda empurrem as de baixo
#Melhorar as cores
#Tentar embaralhar mais as peças

extends Node3D

var starting = true

@export var height = 8
@export var width = 20
@export (int) var x_start
@export (int) var y_start
@export (int) var offset
var all_pieces = []

var cell = load("res://Objects/cell.tscn")
var cellType
var spawnCD = Timer.new()
var cell_queue

func _ready():
	randomize()
	all_pieces = make_2d_array()
	
#	spawnCD.one_shot = true
	spawnCD.connect("timeout", Callable(self, "spawn_cell"))
	add_child(spawnCD)
	
	initial_spawn()

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func initial_spawn():
	cell_queue = 160
	spawnCD.start(0.03)

func spawn_cell():
	var newCell = cell.instantiate()
	newCell.position = $Spawner.position
	newCell.rotation = $Spawner.rotation
	add_child(newCell)
	$Spawner.rotate(Vector3(0,1,0),0.314159)
	cell_queue -= 1
	if cell_queue <= 0:
		spawnCD.stop()

func spawn_ring():
	for i in 20:
		spawn_cell()

func tic_toc_spawner():
#	1/sec
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		spawn_ring()


#Criar peça no cenário						OK!
#Criar peça colorida no cenário				OK!
#Criar anel									OK!
#Criar anel com cores aleatórias			OK!
#Adicionar rigidbody, peso e chão			OK!
#Adicionar zona limite pra peças (teto)		
#Travar queda das peças no eixo Y			OK?
#Fazer com que as peças não quiquem			OK!
#Fazer com que peças formem um cilindro		OK!
#Criar peça como child do anel mais baixo
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


func _on_SpawnTimer_timeout():
	pass # Replace with function body.

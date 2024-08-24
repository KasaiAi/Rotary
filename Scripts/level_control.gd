extends Node3D

# Raycast variables
var mousePos
var rayOrigin
var rayEnd

# Cell creation variables
var cellObject = load("res://Objects/cell.tscn")

var spawnTime = 0.8
var score = 0.0

func _ready():
	randomize()
#	await get_tree().create_timer(2).timeout # Countdown to start
#	show time on screen before game starts
	startup(100)

# Spawn cells when game startas
func startup(initialSpawn):
	if initialSpawn > 0:
		$SpawnTimer.start(0.03)
		await $SpawnTimer.timeout
		Global.emit_signal("wake_up")
		initialSpawn -= 1
		startup(initialSpawn)
	if initialSpawn <= 0:
		$SpawnTimer.start(spawnTime)
#		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
	spawn_cell()
	spawnTime -= 0.001
	$SpawnTimer.start(spawnTime)

# Create one cell
func spawn_cell(amount:int = 1):
	if $Spawner/Killer.danger == true:
		get_tree().paused = true
		$Gameover.visible = true
	for i in amount:
		var newCell = cellObject.instantiate()
		newCell.transform = $Spawner.global_transform
		
		newCell.connect("landed", _on_cell_landed)
		newCell.connect("falling", _on_cell_falling)
		add_child(newCell)
		move_spawn_point()

# Create one layer of cells
func spawn_ring():
	spawn_cell(19)
	Global.emit_signal("wake_up")

func move_spawn_point():
	$Spawner.rotate(Vector3(0,1,0),PI/10)

func _on_cell_falling(cell):
	cell.reparent(self)

# Cell adjustments upon landing (reparenting and rotation)
func _on_cell_landed(cell):
	cell.level = roundi(cell.global_position.y/2)
	var layer # Temp variable for the cell's ring node
#	print("Landed! Layer ",level)
	
	# Set cell level according to height in world
	match cell.level:
		7, 8:
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
		# Change parent, keep global transform
		cell.reparent(layer, true)
		# Freeze physics to reduce jitter (not sure it works at all)
		if cell.global_position.y == cell.level*2:
			cell.freeze = true
		# Fix cell rotation upon reparenting
		cell.rotation.y = snappedf(cell.rotation.y, PI/10)
	
#	# Clipping fix? WIP
#	if cell.get_node("Inside").is_colliding():
#		var collider = cell.get_node("Inside").get_collider()
#		if collider.is_in_group("cells"):
#			if not cell.get_node("Right").is_colliding():
#				cell.rotate_y(PI/10)
#			elif not cell.get_node("Left").is_colliding():
#				cell.rotate_y(-PI/10)
	
#	# Falling combo (must activate only after click)
#	if Global.combo > 1:
#		search_and_destroy(cell)
#
#	if cell.global_position.y >= 13:
#		cell.get_node("Mesh/AnimationPlayer").play("danger")
#	else:
#		cell.get_node("Mesh/AnimationPlayer").stop()
#		cell.set_color()

# Score updater
func updateScore(amount):
	var addScore = amount * (1+(((amount/4)-1)/2.0)) # Multiplier goes up by 0.5 every 4 pieces
	addScore = addScore * Global.combo # Wombo combo
	score += floor(addScore)
	$Score.text = "Score: " + str(score)

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
			search_and_destroy(object)

func search_and_destroy(start):
	start.contiguousCheck()
	Global.emit_signal("release")
	if Global.matchCount >= 4:
		Global.combo += 1
		print(Global.combo)
		updateScore(Global.matchCount)
	else:
		Global.combo = 1
		print(Global.combo)
	Global.matchCount = 0

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

# Reset after gameover
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

#Criar condição pra não destruir depois de arrastar		
#Mudar método da rotação pra sair a partir das peças	
#Iluminar peças contíguas								
#Sistema de pontuação									parcial
#Acelerar timer de spawn com o tempo					
#Rotacionar spawn com o cilindro						
#Redimensionar a tela, onjetos e adicionar UI			
#Melhorar/variar mais as cores							

## Bugs nó-cego
#Consertar o bug do cubo extra no cell.tscn				OK!
#Peças não se movem quando as de baixo somem			OK!
#Peças flutuantes disparam quando soltas				OK!
#Raycast é bloqueado pelos colisores dos anéis			OK!
#Sinal de aterrissagem tá duplicado sem motivo			OK!
#Peças tremem quando estão paradas						OK!
#Com freeze ou sem freeze?								OK!
#Consertar rotação da peça quando entra no anel			OK!
#Consertar peças caindo dentro de outras				
#Consertar iluminação									

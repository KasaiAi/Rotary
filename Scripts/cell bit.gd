extends RigidBody3D

var spinX = randf_range(-.3, .3)
var spinY = randf_range(-.3, .3)

func _ready():
	# Explosão de pedacinhos
	apply_central_impulse(Vector3(randf_range(-5,5),10,randf_range(-5,5)))

func _process(_delta):
	# Limpeza de objetos fora de tela
	if position.y < -25:
		queue_free()
#		print("Morri")
	
	# Girozin aleatório
	$Mesh.rotate_x(spinX)
	$Mesh.rotate_y(spinY)

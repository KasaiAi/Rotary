extends MeshInstance

# Declare member variables here. Examples:
var cellType = randi() % 4 # Número aleatório entre 0 e 4
var material = get_surface_material(0) # Chama o material da malha

# Called when the node enters the scene tree for the first time.
func _ready():
	match cellType: # Switch case para as quatro cores
		0:
			# Só funciona porque tá instanciado, eu acho;
			# muda a cor (albedo) do material
			material.albedo_color = Color(0.82,0.08,0.08) # Red
		1:
			material.albedo_color = Color(0.16,0.68,0.32) # Green
		2:
			material.albedo_color = Color(0.1,0.3,0.8) # Blue
		3:
			material.albedo_color = Color(0.83,0.78,0.1) # Yellow
	
	get_parent().translation.z += 5.25
#	pass


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
##	cellType = randi() % 4
##	print(cellType)
#	pass

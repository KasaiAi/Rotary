extends Spatial

# Declare member variables here. Examples:
#var red_cell = load("res://scenes/red cell.tscn")
#var blue_cell = load("res://scenes/blue cell.tscn")
#var green_cell = load("res://scenes/green cell.tscn")
#var yellow_cell = load("res://scenes/yellow cell.tscn")
#var cell = load("res://scenes/cell.tscn")
#var cellType
#var spawnCD = 0
#var cell_queue = 160
#
#func spawn_cell(amount):
#	if spawnCD >= 0.015:
#		var newCell = cell.instance()
#		newCell.translation = self.translation
#		newCell.rotation = self.rotation
#		get_parent().add_child(newCell)
#		rotate(Vector3(0,1,0),0.314159)
#		cell_queue -= 1
#		spawnCD = 0
#		print(cell_queue)
#
#func insta_spawn_cell(amount):
#	for i in range(amount):
#		var newCell = cell.instance()
#		newCell.translation = self.translation
#		newCell.rotation = self.rotation
#		get_parent().add_child(newCell)
#		rotate(Vector3(0,1,0),0.314159)
#
#func spawn_ring():
#	spawn_cell(20)
#
#func _process(delta):
#	spawnCD += delta
#	if cell_queue > 0:
#		spawn_cell(cell_queue)
#	if Input.is_action_just_pressed("ui_down"):
#		insta_spawn_cell(20)

#Quando o bloco for destruído
#get_parent().addChild(cube)

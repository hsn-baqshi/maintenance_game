extends Node


var unit_selected : String
@onready var spawn = preload("res://Global/spawn_unit.tscn")
var Wood = 10
var Gold = 100
var Coin = 0


func spawnUnit(pos):
	var path = get_tree().get_root().get_node("World/UI")
	var hasSpawn = false
	
	for i in path.get_child_count():
		if "SpawnUnit" in path.get_child(i).name :
			hasSpawn = true
	if !hasSpawn:
		var spawnUnit = spawn.instantiate()
		spawnUnit.housePos = pos
		path.add_child(spawnUnit)

func building_cursor(val):
	unit_selected = val
		#building_cursor_icon.visible = val

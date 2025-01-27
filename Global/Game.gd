extends Node

var spawnedwindow
var unit_selected : String
@onready var spawn = preload("res://Global/spawn_unit.tscn")
var Wood = 10
var Gold = 100
var Coin = 0
var Production = 0
var Ammo = 0
var Profit_margin = 100 # $/L
var counter = 0
var previous_margin 
var selected_body

func gen_rand(x,y):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randx = rng.randf_range(x,y)
	return randx

func _ready() -> void:
	Profit_margin=snapped(gen_rand(0.3,1),0.01)


func _process(delta: float) -> void:
	counter += delta 
	if counter > 50 :
		counter = 0
		previous_margin = Profit_margin
		Profit_margin=gen_rand(0.3,1)
		

func spawnUnit(pos,return_something = false):
	var path = get_tree().get_root().get_node("World/UI")
	var hasSpawn = false
	
	for i in path.get_child_count():
		if "SpawnUnit" in path.get_child(i).name :
			hasSpawn = true
	if !hasSpawn:
		var spawnUnit = spawn.instantiate()
		spawnUnit.housePos = pos
		spawnedwindow = spawnUnit
		path.add_child(spawnUnit)
		if return_something:
			return spawnUnit

func return_body(bodyy):
	selected_body = bodyy
	

func building_cursor(val):
	unit_selected = val
		#building_cursor_icon.visible = val

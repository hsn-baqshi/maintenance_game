extends Node2D

@onready var tech_unit = preload("res://scenes/technician.tscn")
var housePos = Vector2(300,300)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _on_yes_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randx = rng.randi_range(50,60)
	#var randy = rng.randi_range(-50,50)
	
	var unitPath = get_tree().get_root().get_node("World")
	if Game.Wood> 0 :
		Game.Wood -= 1
		var tech = tech_unit.instantiate()
		tech.position = housePos + Vector2(0,randx)
		unitPath.add_child(tech)
		unitPath.get_units()


func _on_no_pressed():
	var housePath = get_tree().get_root().get_node("World/Houses")
	for i in housePath.get_child_count() :
			if housePath.get_child(i).selected == true :
				housePath.get_child(i).selected = false
	queue_free()

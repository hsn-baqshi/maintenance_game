extends Node2D
var mouseEntered = false
@onready var tech_unit = preload("res://scenes/technician.tscn")
var housePos = Vector2(300,300)
@export var spawning_time = 10
var spawn_unit_timer = 0
var allow_spawn : bool = false
@export var spawning_bar : ProgressBar
@export var technician_cost : int = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	spawning_bar.max_value = spawning_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	spawning_bar.value = spawn_unit_timer
	if spawn_unit_timer > 0 :
		spawn_unit_timer -= delta
	if spawn_unit_timer <= 0 and allow_spawn : 
		print("I passed the if condition")
		spawn_tech()
		allow_spawn = false

func spawn_tech() :
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randx = rng.randi_range(50,60)
	var tech = tech_unit.instantiate()
	var unitPath = get_tree().get_root().get_node("World")
	tech.position = housePos + Vector2(0,randx)
	
	unitPath.add_child(tech)
	unitPath.get_units()

func _on_yes_pressed():
	#spawning_bar.position = housePos #+ Vector2(0,-100)
	if Game.Gold>= technician_cost and spawn_unit_timer <= 0 :
		allow_spawn = true
		spawn_unit_timer = spawning_time
		Game.Gold -= technician_cost



func _on_no_pressed():
	if spawn_unit_timer > 0 :
		Game.Gold += technician_cost
	var housePath = get_tree().get_root().get_node("World/Houses")
	for i in housePath.get_child_count() :
			if housePath.get_child(i).selected == true :
				housePath.get_child(i).selected = false
	queue_free()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and !mouseEntered:
		#visible=false
		if spawn_unit_timer <= 0 or spawn_unit_timer >= spawning_time :
			queue_free()
	if event.is_action_pressed("LeftClick") and mouseEntered:
		visible=true
		
		
func _on_area_2d_mouse_entered() -> void:
	mouseEntered = true
	print(mouseEntered)


func _on_area_2d_mouse_exited() -> void:
	mouseEntered = false
	print(mouseEntered)


func _on_panel_mouse_entered() -> void:
	mouseEntered = true
	print(mouseEntered)


func _on_panel_mouse_exited() -> void:
	mouseEntered = false
	print(mouseEntered)


func _on_yes_mouse_entered() -> void:
	mouseEntered = true
	print(mouseEntered)


func _on_yes_mouse_exited() -> void:
	#mouseEntered = false
	print(mouseEntered)

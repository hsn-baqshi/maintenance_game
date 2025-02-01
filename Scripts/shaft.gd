extends StaticBody2D

var building_cursor_icon  = load("res://assets/building_cursor.png")
@export var spare_image : Sprite2D
var mouseEntered = false
var pickable : bool = false
var go_pick : bool = false
var unit_nearby : bool = false
var new_parent 
@export var coll : CollisionShape2D
var picked : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		if pickable :
			go_pick = true
			print("go pick is true ")
		elif !pickable:
			go_pick = false

func set_picked(val):
	picked = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if go_pick and unit_nearby:
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		if picked :
			go_pick = false
	if !go_pick:
		set_collision_layer_value(2, true)
		set_collision_layer_value(1, false)


func _on_mouse_entered() -> void:
	print("is the layer 1 ? : ",get_collision_layer_value(1))
	print("is the layer 2 ? : ",get_collision_layer_value(2))
	if Game.unit_selected == "technician" :
		print("should be YES mouseEntered ", mouseEntered)
		Input.set_custom_mouse_cursor(building_cursor_icon)
		pickable = true
	mouseEntered = true
	

func _on_mouse_exited() -> void:
	mouseEntered = false
	Input.set_custom_mouse_cursor(null)
	pickable = false

func _on_pickuparea_body_entered(body: Node2D) -> void:
	if body.is_in_group("units"):
		print("technician approached")
		unit_nearby = true

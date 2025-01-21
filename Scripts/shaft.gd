extends RigidBody2D

var building_cursor_icon  = load("res://assets/building_cursor.png")
var mouseEntered = false
var pickable : bool = false
var go_pick : bool = false
var unit_nearby : bool = false
var new_parent 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		if pickable :
			go_pick = true
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if go_pick and unit_nearby:
		go_pick = false
		if new_parent :
			new_parent.add_child(self)

func _on_mouse_entered() -> void:
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
	if body.is_in_group("unit"):
		print("technician approached")
		unit_nearby = true
		new_parent = body
		

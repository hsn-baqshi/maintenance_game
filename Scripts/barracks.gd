extends StaticBody2D

var mouseEntered = false
@export var select : Panel
var selected = false
var building_cursor_icon  = load("res://assets/building_cursor.png")
var regular_cursor_icon  = load("res://assets/back_punch.png")

@export var initial_age : int = 1000
var age = 1000
@export var age_label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	age = initial_age


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	age -= delta
	age_label.text = "RUL : " + str(age)
	if mouseEntered and Game.unit_selected == "technician":
		Input.set_custom_mouse_cursor(building_cursor_icon)
		
	else:
		Input.set_custom_mouse_cursor(regular_cursor_icon)
	select.visible = selected
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		age = 1000
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			selected = !selected
			if selected:
				Game.spawnUnit(position)

func _on_mouse_entered() -> void:
	mouseEntered = true


func _on_mouse_exited() -> void:
	mouseEntered = false

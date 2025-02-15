extends StaticBody2D

var window
var POP = preload("res://Global/pop.tscn")
var mouseEntered = false
@export var select : Panel
@export var select_label : Label
var selected = false
var building_cursor_icon  = load("res://assets/building_cursor.png")
var counter : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select_label.text = str(selected)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if mouseEntered :
			select.visible = true
			selected = true
			#Game.spawnUnit(position,1)
			Game.spawnUnit(position,2)
		if !mouseEntered:
			select.visible = false
			selected = false

func _on_mouse_entered() -> void:
	print("I am over the barracks")
	mouseEntered = true

func _on_mouse_exited() -> void:
	print("I am NOT over the barracks")
	mouseEntered = false

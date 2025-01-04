extends StaticBody2D

var mouseEntered = false
@export var select : Panel
var selected = false
@export var building_cursor_icon : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select.visible = selected

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		if mouseEntered and Game.unit_selected == "technician":
			building_cursor_icon.position = get_global_mouse_position()
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			selected = !selected
			if selected:
				Game.spawnUnit(position)

func _on_mouse_entered() -> void:
	mouseEntered = true


func _on_mouse_exited() -> void:
	mouseEntered = false

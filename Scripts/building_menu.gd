extends Node2D

@onready var spare_unit = preload("res://scenes/canon.tscn")
var val: Node2D = null
var under_placement: bool = false
var unitPath
var mouseEntered: bool = false
var grid_size: int = 16  # Define the size of each grid cell

func _ready() -> void:
	unitPath = get_tree().get_root().get_node_or_null("World")

func _process(delta: float) -> void:
	if val and under_placement:
		# Get mouse position in world space
		var mouse_pos = get_global_mouse_position() / unitPath.get_node("Camera").zoom.y
		# Snap position to grid
		val.global_position = Vector2(
			snappedf(mouse_pos.x, grid_size),
			snappedf(mouse_pos.y, grid_size)
		)

func _on_button_button_down() -> void:
	mouseEntered = true
	if Game.Gold >= 100:
		under_placement = true
		val = spare_unit.instantiate()
		unitPath.add_child(val)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and under_placement:
		Game.Gold -= 100
		under_placement = false
		val = null  

	if event.is_action_pressed("RightClick") and under_placement and val:
		val.queue_free()
		under_placement = false
		val = null

	if event.is_action_pressed("LeftClick") and !under_placement and !mouseEntered:
		queue_free()

func _on_button_mouse_entered() -> void:
	mouseEntered = true

func _on_button_mouse_exited() -> void:
	mouseEntered = false

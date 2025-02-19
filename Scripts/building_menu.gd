extends Node2D

@onready var spare_unit = preload("res://scenes/canon.tscn")
var val: Node2D = null
var under_placement: bool = false
var unitPath
var mouseEntered: bool = false
var grid_size: int = 16  # Define the size of each grid cell
var builder 

func _ready() -> void:
	if Game.selected_body != null:
		builder = Game.selected_body
	unitPath = get_tree().get_root().get_node_or_null("World")

func _process(delta: float) -> void:
	if val and under_placement:
		
		# Get mouse position in world space
		var mouse_pos = get_global_mouse_position() / unitPath.get_node("Camera").zoom.y
		
		# Calculate the distance between the builder and the mouse position
		var offset = mouse_pos - builder.global_position
		if offset.length() > 50:
			offset = offset.normalized() * 50  # Limit distance to 200 pixels

		# Snap position to grid and apply offset
		val.global_position = Vector2(
			snappedf(builder.global_position.x + offset.x, grid_size),
			snappedf(builder.global_position.y + offset.y, grid_size)
		)
		val.modulate.a = 0.5
		if !val.buildable :
			val.modulate.b = 0
			val.modulate.g = 0
		if val.buildable :
			val.modulate.b = 1
			val.modulate.g = 1
func _on_button_button_down() -> void:

	mouseEntered = true
	if Game.Gold >= 100:
		under_placement = true
		val = spare_unit.instantiate()
		unitPath.add_child(val)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and under_placement and val.buildable :
		val.modulate.a = 1
		Game.Gold -= 100
		under_placement = false
		val = null  
		builder = null

	if event.is_action_pressed("RightClick") and under_placement and val:
		val.queue_free()
		under_placement = false
		val = null
		builder = null

	if event.is_action_pressed("LeftClick") and !under_placement and !mouseEntered:
		queue_free()

func _on_button_mouse_entered() -> void:
	mouseEntered = true

func _on_button_mouse_exited() -> void:
	mouseEntered = false

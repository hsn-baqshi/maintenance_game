extends StaticBody2D

@export var driver : bool = false
@export var level_bar : ProgressBar
@export var level : float = 10
var reduce : bool = false
var mouseEntered : bool = false
var operate_cursor_icon  = load("res://assets/gear_cursor.png")
var is_carried : bool = false
@export var suction_area : Area2D
var resource = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if resource != null and level < 100:
		level += 0.1
		resource.get_smaller(0.9999)
	if is_carried :
		suction_area.global_position = get_global_mouse_position() - Vector2(50,0)
	level_bar.value = level
	if reduce and level > 0:
		level -= delta
		if level <= 0 :
			level = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and mouseEntered and driver:
		is_carried = !is_carried


func reduce_level(val):
	reduce = val

func return_level():
	return level

func _on_area_2d_2_mouse_entered() -> void:
	mouseEntered = true
	if driver:
		Input.set_custom_mouse_cursor(operate_cursor_icon)

func _on_area_2d_2_mouse_exited() -> void:
	mouseEntered = false
	if driver:
		Input.set_custom_mouse_cursor(null)

#Resource suction area vvvv
func _on_suction_area_body_entered(body: Node2D) -> void:
	if is_carried and body.is_in_group("resource"):
		resource = body

func _on_suction_area_body_exited(body: Node2D) -> void:
	if is_carried and body.is_in_group("resource"):
		resource = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("units"):
		driver = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("units"):
		driver = false


func _on_area_2d_mouse_entered() -> void:
	if Game.unit_selected == "technician"  :
		Input.set_custom_mouse_cursor(operate_cursor_icon)


func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)

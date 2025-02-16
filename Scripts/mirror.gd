extends Area2D
var select : bool = false
@export var head : AnimatedSprite2D
var mouseEntered : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if select:
		var head_direction = get_global_mouse_position() - global_position
		head_direction = head_direction.angle()+PI/2
		rotation = head_direction

func _input(event: InputEvent) -> void:
	if mouseEntered and event.is_action_pressed("LeftClick"):
		select = true
	elif !mouseEntered: 
		if event.is_action_pressed("LeftClick") or event.is_action_pressed("RightClick"):
			select = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		body.rotation = rotation
		body.linear_velocity = -500*Vector2.from_angle(rotation+PI/2)


func _on_mouse_entered() -> void:
	mouseEntered = true


func _on_mouse_exited() -> void:
	mouseEntered = false

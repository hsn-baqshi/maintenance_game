extends RigidBody2D
@export var turning : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if turning:
		rotation += delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("gear"):
		turning = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("gear"):
		turning = false

extends RigidBody2D

@export var shape : String = "star"
@export var is_active : bool = true
@export var turning : bool =false
@export var self_or_not : Label
var sign = 1
var print_body
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self_or_not.text = str(print_body)
	if turning :
		rotation += sign*delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("gear") and body!=self:
		print_body=body
		if body.rotation > 0 and body.turning :
			sign = -body.rotation
		turning = true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("gear"):
		turning = false

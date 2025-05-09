extends RigidBody2D
@export var smoke : CPUParticles2D
@export var coll : CollisionShape2D
@export var shape : String = "star"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet") and body.shape == shape and body.is_active :
		body.is_active = false
		smoke.emitting = true
		coll.scale -= Vector2(0.1,0.1)

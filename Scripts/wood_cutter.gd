extends Sprite2D
@export var cutting : bool = false
var x = 0
@export var gear : Sprite2D
@export var gear2 : Sprite2D
@export var lever : TextureRect
@export var tip : Sprite2D
var resource 
@export var threshold : int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_cutting(val:bool):
	if resource :
		cutting = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gear.rotation = x
	gear2.rotation = x
	lever.rotation = -0.4*sin(x)
	lever.position.x = -2 + 15*cos(x)
	tip.position.y = 10*sin(x)
	tip.position.x = 46 + 15*cos(x)
	if cutting and resource != null:
		x += 0.05
		if x > threshold and false :
			x=0
			if resource != null :
				resource.gain_wood(threshold)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("resource"):
		resource = body
		start_cutting(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("resource"):
		resource = null
		start_cutting(false)

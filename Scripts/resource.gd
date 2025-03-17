extends RigidBody2D
@export var coll : CollisionShape2D
var mouseEntered : bool = false
var operate_cursor_icon  = load("res://assets/axe.png")
@export var splash : CPUParticles2D
@export var inital_value : int = 500
var inital_value_rand : int = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	inital_value_rand = rng.randf_range(inital_value*0.7,inital_value)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#pass

func get_smaller(val=0.9):
	coll.scale *= val

func gain_wood(x):
	inital_value_rand -= x 
	Game.Wood += x
	splash.emitting = true
	get_smaller(0.999)
	if inital_value_rand <= 0 :
		if mouseEntered:
			Input.set_custom_mouse_cursor(null)
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and mouseEntered:
		gain_wood(1)

		
func _on_mouse_entered() -> void:
	mouseEntered = true
	Input.set_custom_mouse_cursor(operate_cursor_icon)
	


func _on_mouse_exited() -> void:
	mouseEntered = false
	Input.set_custom_mouse_cursor(null)

		

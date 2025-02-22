extends RigidBody2D
var mouseEntered : bool = false
var health : int = 15
@export var health_bar : ProgressBar
@export var splash : CPUParticles2D
@export var labelee : Label
@export var anim : AnimatedSprite2D
@export var small_circle : Sprite2D
var x : float = 0
var y : float = 0
var attacking_cursor_icon  = load("res://assets/axe.png")
@onready var meat = preload("res://scenes/meat.tscn")

var counter : float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health

func gen_rand(x,y):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randx = rng.randf_range(x,y)
	return randx


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("the linear velocity is ",linear_velocity)
	if linear_velocity.length() > 0.1:
		small_circle.rotation += delta
		anim.play("walk")
	if linear_velocity.x > 0 :
		anim.flip_h = false
	elif linear_velocity.x < 0 :
		anim.flip_h = true
	if abs(linear_velocity.x) < 0.1 or abs(linear_velocity.y) < 0.1:
		linear_velocity = Vector2(0,0)
		anim.stop()
	counter += delta
	if counter > 1 :
		linear_velocity = 5*Vector2(x,y)
		if counter > 2 :
			counter = 0
			x = gen_rand(-20,20)
			y = gen_rand(-20,20)
	health_bar.value = health
	labelee.text = str(mouseEntered)


func _input(event: InputEvent) -> void:
	pass
	
func spawn_meat():
	var meato = meat.instantiate()
	#tech.position = global_position
	meato.global_position = global_position
	get_parent().add_child(meato)

func _on_mouse_entered() -> void:
	print("target is found!")
	if Game.unit_selected == "technician":
		mouseEntered = true
		Input.set_custom_mouse_cursor(attacking_cursor_icon)


func _on_mouse_exited() -> void:
	mouseEntered = false
	Input.set_custom_mouse_cursor(null)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet") and health > 0 :
		splash.emitting = true
		body.queue_free()
		if health == 1 :
			Game.Gold += 100
			spawn_meat()
			queue_free()
			
		else : 
			health -= 1



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bullet") and health > 0 :
		body.queue_free()
		if health == 1 :
			queue_free()
		else : 
			health -= 1

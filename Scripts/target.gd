extends CharacterBody2D
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

var own_bullets 
var speed = 50
var accel = 7
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@export var main_tower : Node2D
@export var enemy_distance_threshold = 100
@onready var tech_unit = preload("res://scenes/bullet.tscn")
@export var dummy_target : Node2D
var target
var counter2 : float = 0
var counter : float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	target = main_tower

func gen_rand(x,y):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randx = rng.randf_range(x,y)
	return randx


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("the linear velocity is ",linear_velocity)
	if velocity.length() > 0.1:
		small_circle.rotation += delta
		anim.play("walk")
	if velocity.x > 0 :
		anim.flip_h = false
	elif velocity.x < 0 :
		anim.flip_h = true
	if velocity.length() < 0.1:
		velocity = Vector2(0,0)
		anim.stop()

	counter += delta
	if counter > 1 :
		#linear_velocity = 5*Vector2(x,y)
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
	if body.is_in_group("bullet") and health > 0 and body != own_bullets :
		print("the bullet parent is ",body.get_parent())
		print("is the bullet parent self ? ",body.get_parent()==self)
		splash.emitting = true
		body.queue_free()
		if health == 1 :
			Game.Gold += 100
			spawn_meat()
			queue_free()
		else : 
			health -= 1



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bullet") and health > 0 and body != own_bullets:
		body.queue_free()
		if health == 1 :
			queue_free()
		else : 
			health -= 1
			


func shoot(direction,powerr=100):
	var tech = tech_unit.instantiate()
	own_bullets = tech
	tech.global_position = global_position 
	tech.linear_velocity = powerr*(direction-global_position).normalized()
	print("tech is ", tech)
	#add_child(tech)
	get_parent().add_child(tech)
	#get_tree().create_timer(10).timeout
	#tech.queue_free()

func _physics_process(delta: float) -> void:
	if dummy_target != null:
		dummy_target.global_position = get_global_mouse_position()
	#print("The distance : ")
	#print(global_position.distance_to(target.global_position))
	if global_position.distance_to(target.global_position) < enemy_distance_threshold : 
		#print("thte distance is short")
		counter2 += 1
		if counter2 > 50 :
			#print("I am here")
			shoot(target.global_position)
			counter2 = 0
			
	else:
		var direction = Vector3()
		nav.target_position = target.global_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed,accel*delta)
		move_and_slide()


func _on_target_range_body_entered(body) :
	if body.is_in_group("target") and body != self:
		target = body


func _on_target_range_body_exited(body):
	if body.is_in_group("target") and body != self:
		target = main_tower

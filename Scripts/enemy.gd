extends CharacterBody2D

var speed = 50
var accel = 7
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@export var main_tower : Node2D
@export var enemy_distance_threshold = 100
@onready var tech_unit = preload("res://scenes/bullet.tscn")
@export var dummy_target : Node2D
var target
var counter : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = main_tower

func shoot(direction,powerr=100):
	var tech = tech_unit.instantiate()
	tech.global_position = global_position
	tech.linear_velocity = powerr*(direction-global_position).normalized()
	get_parent().add_child(tech)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if dummy_target != null:
		dummy_target.global_position = get_global_mouse_position()
	#print("The distance : ")
	#print(global_position.distance_to(target.global_position))
	if global_position.distance_to(target.global_position) < enemy_distance_threshold : 
		counter += 1
		if counter > 10 :
			counter = 0
			shoot(target.global_position)
	else:
		var direction = Vector3()
		nav.target_position = target.global_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed,accel*delta)
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		print("hello")
		#print(dummy_target)
		#var dummy_target1 = dummy_target.instantiate()
		#dummy_target1.global_position = Vector2(0,0)
		#print("the location of the dummy target is : ",dummy_target1.global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("target") and body != self:
		target = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("target") and body != self:
		target = main_tower

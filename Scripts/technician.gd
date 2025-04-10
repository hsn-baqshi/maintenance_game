extends CharacterBody2D
var equipment = []
@export var chill : Label
var rank : int = 1
var initial_rank : int
@export var rank_sprite : TextureRect
@export var selected = false
@export var box : Panel
@onready var target = position
@export var anim : AnimatedSprite2D
var mouseEntered : bool = false
var follow_cursor = false
var initial_speed = 70
var speed = 70
var is_carrying : bool = false
@export var slow_speed : int = 50
var picked_up_object = null
var original_pos : Vector2 = Vector2(0,0)
@export var drop_button : Button
@export var energy : float = 100
@export var energy_bar : ProgressBar 
@export var energy_timer : Timer
@export var move_arrow : GPUParticles2D
var is_working : bool = false
@export var drop_item_button : Button
#var building_menu = null
@onready var building_menu = preload("res://scenes/building_menu.tscn")
var charging : bool = false
var power : int = 0
@onready var tech_unit = preload("res://scenes/shooting_arrow.tscn")
@export var bow : AnimatedSprite2D
var selected_equipment
var go_hunt : bool = false
var hunt_target 
var attack_timer : float = 0
@export var target_area : Area2D
var there_is_a_hunt_target
var potential_target
func _ready():
	energy_bar.max_value=energy
	initial_rank = rank_sprite.size.y
	set_selected(selected)
	add_to_group("units",true)
	
func working(val):
	is_working = val

func hunt(goal:Node2D):
	pass
	#go_hunt = true
	#hunt_target = goal

	
func stop_moving():
	target = position

func set_selected(value):
	selected = value
	box.visible = value 
	if selected:
		target_area.monitoring = true
		Game.building_cursor("technician")
		Game.return_body(self)
		var path = get_tree().get_root().get_node("World/UI")
		var tech = building_menu.instantiate()
		path.add_child(tech)
	elif !selected:
		target_area.monitoring = false
		Game.building_cursor("")
		Game.return_body(null)

func set_carry(val: bool = true):
	is_carrying = val

func return_carrying():
	return is_carrying

func add_rank(val):
	rank += val
	rank_sprite.size.y += val*initial_rank

func shoot(powerr,is_hunt_target=false):
	var head_direction = Vector2(0,0)
	if is_hunt_target :
		head_direction = hunt_target.global_position - global_position
	else:
		head_direction = get_global_mouse_position() - global_position
	var tech = tech_unit.instantiate()
	bow.play("shoot")
	tech.global_position = global_position
	tech.rotation = head_direction.angle()+PI/2
	tech.linear_velocity = powerr*head_direction.normalized()
	get_parent().add_child(tech)

func _input(event):
	if selected and event.is_action_pressed("RightClick") and there_is_a_hunt_target:
		hunt_target = potential_target
		
	if selected and event.is_action_pressed("one") and equipment != []:
		print("bow is selected!")
		bow.visible = true
		selected_equipment = equipment[0]
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			set_selected(true)
		else:
			set_selected(false)
	if  event.is_action_pressed("RightClick") and selected and !there_is_a_hunt_target:
		
		hunt_target = null
	if  event.is_action_pressed("RightClick") and selected :
		follow_cursor=true
		move_arrow.global_position = get_global_mouse_position()
		move_arrow.emitting = true
		#hunt_target = null
	if  event.is_action_released("RightClick") and selected :
		follow_cursor = false
	if selected_equipment == "bow":
		
		if selected and event.is_action_released("ui_accept") and charging :
			charging = false
			shoot(power,true)
			power = 0
		if selected and event.is_action_pressed("ui_accept") and Game.Ammo > 0:
			Game.Ammo -= 1
			charging = true
			bow.play("charge")


func _physics_process(delta):
	if velocity.length()>0:
		move_and_slide()
	if selected:
		target_area.global_position = get_global_mouse_position()
	if energy <= 0 :
		stop_moving()
		energy_timer.start()
	if follow_cursor and selected :
		target = get_global_mouse_position()
	if position.distance_to(target) > 10 and energy > 0 :
		velocity = position.direction_to(target)*speed
		#move_and_slide()
	else:
		velocity = Vector2.ZERO
		anim.stop()
		energy += 0.05
	if hunt_target != null :
		print("hunt target is ", hunt_target)
		if position.distance_to(hunt_target.global_position) < 100 :
			attack_timer += delta
			if attack_timer > 1 :
				stop_moving()
				attack_timer = 0
				shoot(500,true)
		elif position.distance_to(hunt_target.global_position) >= 80:
			velocity = global_position.direction_to(hunt_target.global_position).normalized()*speed
			#move_and_slide()
		if charging and power < 500 :
			power += 10


	if abs(velocity) > Vector2.ZERO and picked_up_object != null :
		energy -= 0.1

func _process(delta):
	## shooting part
	chill.text = str(power)
	if charging and power < 500 :
		power += 10
	if selected:
		var head_direction = get_global_mouse_position() - global_position
		head_direction = head_direction.angle()+PI/2
		bow.rotation = head_direction
	### non-shooting part
	if is_working :
		energy -= 0.1
	energy_bar.value = energy
	drop_button.visible = is_carrying
	if picked_up_object == null:
		is_carrying=false
	if is_carrying:
		speed = slow_speed
	elif !is_carrying:
		speed = initial_speed
	if velocity.length() > 0.1:
		anim.play("Walk Down")
	else:
		anim.play("Idle")
	if velocity.x > 0 :
		anim.flip_h = false
	elif velocity.x < 0 :
		anim.flip_h = true
	if abs(velocity.x) < 0.1 or abs(velocity.y) < 0.1:
		velocity = Vector2(0,0)
		anim.stop()

func _on_mouse_entered() -> void:
	mouseEntered = true
	#print("I am hovering over the guy")

func _on_mouse_exited() -> void:
	mouseEntered = false
	print("I am NOT hovering over the guy")

func add_spare(ok):
		if ok.get_parent():
			print("the parent is : ")
			print(ok.get_parent())
			add_child(ok)
		move_child(ok, 0)

func pick_up_object(object,remove=false): 
	#original_pos = object.position
	print("character pos is ", position)
	print("object pos is ",object.position)
	if picked_up_object == null: 
		picked_up_object = object 
		picked_up_object.get_parent().remove_child(picked_up_object) 
		add_child(picked_up_object) 
		print(get_children())
		picked_up_object.set_picked(true)
		picked_up_object.position = Vector2(20,-20)

	if picked_up_object != null and remove :
		remove_child(object)
		get_parent().add_child(object)
		picked_up_object.set_picked(false)
		drop_item_button.icon = picked_up_object.building_cursor_icon
		object.global_position = global_position
		picked_up_object=null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spare"):
		#body.position = position
		pick_up_object(body)
		print("I found a spare")
		is_carrying = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("spare"):
		pass

func _on_drop_item_button_down() -> void:
	set_selected(true)
	pick_up_object(picked_up_object,true)
	is_carrying=false


func _on_energy_timer_timeout() -> void:
	speed = initial_speed


func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("target"):
		potential_target = body
		there_is_a_hunt_target = true


func _on_target_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("target"):
		there_is_a_hunt_target = false

extends CharacterBody2D

var rank : int = 1
var initial_rank : int
@export var rank_sprite : TextureRect
@export var selected = false
@export var box : Panel
@onready var target = position
@export var anim : AnimationPlayer
@export var spritee : Sprite2D
var mouseEntered : bool = false
var follow_cursor = false
var speed = 50
var is_carrying : bool = false
@export var slow_speed : int = 20
var picked_up_object 
@export var drop_button : Button
func _ready():
	initial_rank = rank_sprite.size.y
	set_selected(selected)
	add_to_group("units",true)

func set_selected(value):
	selected = value
	box.visible = value 

func set_carry(val: bool = true):
	is_carrying = val

func return_carrying():
	return is_carrying

func add_rank(val):
	rank += val
	rank_sprite.size.y += val*initial_rank


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func _input(event):
	if event.is_action_pressed("LeftClick"):
		picked_up_object = null
		if mouseEntered:
			set_selected(true)
		else:
			set_selected(false)
	if selected : 
		if  event.is_action_pressed("RightClick"):
			follow_cursor=true
		if  event.is_action_released("RightClick"):
			follow_cursor = false

func _physics_process(delta):
	#rank
	if follow_cursor:
		if selected:
			target = get_global_mouse_position()
			anim.play("Walk Down")
	velocity = position.direction_to(target)*speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		anim.stop()

func _process(delta):
	drop_button.visible = is_carrying
	if picked_up_object:
		picked_up_object.position = position
	if picked_up_object == null:
		is_carrying=false
	if is_carrying:
		speed = slow_speed
	elif !is_carrying:
		speed = 50
	if selected:
		Game.building_cursor("technician")
	elif !selected:
		Game.building_cursor("")
	if velocity.x > 0 :
		spritee.flip_h = false
	elif velocity.x < 0 :
		spritee.flip_h = true
	if abs(velocity.x) < 0.1 and abs(velocity.y) < 0.1:
		velocity = Vector2(0,0)
		anim.stop()


func _on_mouse_entered() -> void:
	mouseEntered = true
	print("I am hovering over the guy")

func _on_mouse_exited() -> void:
	mouseEntered = false
	print("I am NOT hovering over the guy")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spare"):
		print("I found a spare")
		picked_up_object = body
		is_carrying = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("spare"):
		pass
		#picked_up_object = null


func _on_drop_item_button_down() -> void:
	set_selected(true)
	picked_up_object = null
	is_carrying=false
	print(is_carrying)

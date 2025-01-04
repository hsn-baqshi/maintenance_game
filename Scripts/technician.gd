extends CharacterBody2D

@export var selected = false
@export var box : Panel
@onready var target = position
@export var anim : AnimationPlayer
@export var spritee : Sprite2D
var follow_cursor = false
var speed = 50

func _ready():
	set_selected(selected)
	add_to_group("units",true)
	
func set_selected(value):
	selected = value
	box.visible = value 


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("RightClick"):
		follow_cursor=true
	if event.is_action_released("RightClick"):
		follow_cursor = false
		

func _physics_process(delta):
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
	if selected:
		Game.building_cursor("technician")
	if velocity.x > 0 :
		spritee.flip_h = false
	elif velocity.x < 0 :
		spritee.flip_h = true
	if abs(velocity.x) < 0.1 and abs(velocity.y) < 0.1:
		velocity = Vector2(0,0)
		anim.stop()

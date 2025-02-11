extends StaticBody2D

@onready var tech_unit = preload("res://scenes/bullet.tscn")
var select : bool = false
@export var head : AnimatedSprite2D
@export var selected_borders : Panel
var mouseEntered : bool = false
@export var tank_canon : bool = false
var target_cursor  = load("res://assets/gear_cursor-export.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	selected_borders.visible = select
	if select:
		var head_direction = (get_global_mouse_position() - global_position).angle()+PI/2
		#head_direction = head_direction.angle()+PI/2
		head.rotation = head_direction
		#print(head.rotation)
		#print(head_direction)

func recoil(direction):
	head.play("shoot")

func _input(event: InputEvent) -> void:
	if mouseEntered and event.is_action_pressed("LeftClick"):
		print("ok")
		Input.set_custom_mouse_cursor(target_cursor)
		select = true
	elif !mouseEntered and event.is_action_pressed("LeftClick"):
		select = false
		Input.set_custom_mouse_cursor(null)
	if select and event.is_action_pressed("RightClick") and Game.Ammo > 0:
		Game.Ammo -= 1
		print("I am shooting")
		var head_direction = get_global_mouse_position() - global_position
		print("the head direction is ",head_direction)
		var tech = tech_unit.instantiate()
		recoil(head_direction)
		#tech.position = global_position
		tech.global_position = global_position
		tech.linear_velocity = 500*head_direction.normalized()
		get_parent().add_child(tech)


func _on_mouse_entered() -> void:
	mouseEntered = true



func _on_mouse_exited() -> void:
	mouseEntered = false

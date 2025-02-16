extends StaticBody2D

@onready var tech_unit = preload("res://scenes/bullet.tscn")
var select : bool = false
@export var head : AnimatedSprite2D
@export var selected_borders : Panel
var mouseEntered : bool = false
@export var tank_canon : bool = false
var power : float = 0
var charging : bool = false
@export var power_label : Label
var keep_shooting : bool = false
var counter : float = 0
@export var auto_button : Button 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	power_label.text = str(power)
	if charging and power < 500 :
		power += 10
	selected_borders.visible = select
	if select:
		var head_direction = get_global_mouse_position() - global_position
		head_direction = head_direction.angle()+PI/2
		head.rotation = head_direction
		#print(head.rotation)
		#print(head_direction)
	if keep_shooting and Game.Ammo > 0 :
		counter += delta*5
		if counter > 5 :
			Game.Ammo -= 1
			print("I am past counter 5 ")
			counter = 0
			var head_direction= Vector2.from_angle(head.rotation-PI/2)
			var tech = tech_unit.instantiate()
			print("the angle is  ",head.rotation)
			recoil(head_direction)
			tech.global_position = global_position
			tech.linear_velocity = 500*head_direction.normalized()
			get_parent().add_child(tech)
func recoil(direction):
	head.play("shoot")

func _input(event: InputEvent) -> void:
	if mouseEntered and event.is_action_pressed("LeftClick"):
		print("ok")
		select = true
		auto_button.visible = true
	elif !mouseEntered and event.is_action_pressed("LeftClick"):
		select = false
		auto_button.visible = false
	if select and event.is_action_released("RightClick") and charging :
		charging = false
		var head_direction = get_global_mouse_position() - global_position
		print("the head direction is ",head_direction)
		var tech = tech_unit.instantiate()
		recoil(head_direction)
		#tech.position = global_position
		tech.global_position = global_position
		tech.linear_velocity = power*head_direction.normalized()
		get_parent().add_child(tech)
		power = 0
		
	if select and event.is_action_pressed("RightClick") and Game.Ammo > 0:
		Game.Ammo -= 1
		charging = true
		print("I am shooting")


func _on_mouse_entered() -> void:
	mouseEntered = true



func _on_mouse_exited() -> void:
	mouseEntered = false


func _on_button_button_down() -> void:
	if Game.Ammo > 0 : 
		keep_shooting = true

extends CanvasLayer

@export var Wood : Label
@export var Gold : Label
@export var Production : Label
@export var Price : Button
@export var amount : int
@export var Ammo : Label
@export var camera : Camera2D
var move_right : bool = false
var move_left : bool = false
var move_up : bool = false
var move_down : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_right:
		camera.position.x += 1
	if move_left:
		camera.position.x -= 1
	if move_up:
		camera.position.y -= 1
	if move_down:
		camera.position.y += 1
	
	#label.text = "Wood : " + str(Game.Wood)
	Ammo.text = "Ammo : " + str(snapped(Game.Ammo,0.01))
	Gold.text = "Gold : " + str(snapped(Game.Gold,0.01)) 
	Production.text = "Production : " + str(snapped(Game.Production,0.01)) + " L"
	Price.text = "Sell : " + str(snapped(amount,0.01)) + "L @"+ str(snapped(Game.Profit_margin,0.01)) + " $/L , GAIN +" + str(snapped(amount*Game.Profit_margin,0.01))
	Wood.text = "Wood : " + str(snapped(Game.Wood,0.0))
func _on_button_button_down() -> void:
	if Game.Production >= amount :
		Game.Production -= amount
		Game.Gold += amount*Game.Profit_margin

func _on_increase_button_down() -> void:
	amount += 1


func _on_decrease_button_down() -> void:
	amount -= 1


func _on_button_2_button_down() -> void:
	if Game.Gold >= 100 :
		Game.Ammo += 10
		Game.Gold -= 100


func _on_moveright_mouse_entered() -> void:
	move_right=true

func _on_moveright_mouse_exited() -> void:
	move_right=false


func _on_moveleft_mouse_entered() -> void:
	move_left=true


func _on_moveleft_mouse_exited() -> void:
	move_left=false


func _on_moveup_mouse_entered() -> void:
	move_up =true


func _on_moveup_mouse_exited() -> void:
	move_up=false


func _on_movedown_mouse_entered() -> void:
	move_down =true


func _on_movedown_mouse_exited() -> void:
	move_down=false


func _on_button_3_button_down() -> void:
	get_tree().quit()


func _on_restart_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

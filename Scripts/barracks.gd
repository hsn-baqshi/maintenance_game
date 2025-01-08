extends StaticBody2D
var production_rate = 0
@export var fan : Sprite2D
@export var age_bar : ProgressBar
@export var increase_button : Button
@export var decrease_button : Button
@export var max_production = 10
@export var production_rate_bar : ProgressBar
var fixable : bool = false
var unit_nearby : bool = false
var POP = preload("res://Global/pop.tscn")
var mouseEntered = false
@export var select : Panel
var selected = false
var building_cursor_icon  = load("res://assets/building_cursor.png")
var regular_cursor_icon  = load("res://assets/back_punch.png")
var counter : float = 0.0
@export var initial_age : int = 1000
var age = 1000
@export var age_label : Label
# Called when the node enters the scene tree for the first time.
@export var connected : bool = false
var fixing_counter : float = 0
var fixing_time : float = 5

func _ready() -> void:
	age = initial_age
	age_bar.max_value = initial_age
	production_rate_bar.max_value = max_production


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fixing_counter > 0 :
		fixing_counter -= delta
	counter += production_rate
	if counter > 200 :
		coinsCollected()
		counter = 0
	age -= 0.02*production_rate
	age_label.text = "RUL : " + str(production_rate)
	age_bar.value = age
	production_rate_bar.value = production_rate
	if mouseEntered and Game.unit_selected == "technician":
		Input.set_custom_mouse_cursor(building_cursor_icon)
		fixable = true
		
		if unit_nearby and fixing_counter <= 0 :
			age = initial_age
			fixable = false
	else:
		Input.set_custom_mouse_cursor(regular_cursor_icon)
		fixable = false
	select.visible = selected
	increase_button.visible = selected
	decrease_button.visible = selected
	production_rate_bar.visible = selected
	fan.rotation += round(production_rate)

	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		if fixable and unit_nearby:
			fixing_counter = fixing_time
			if fixing_counter <= 0:
				age = initial_age
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			selected = !selected
			if selected:
				Game.spawnUnit(position)

func _on_mouse_entered() -> void:
	mouseEntered = true


func _on_mouse_exited() -> void:
	mouseEntered = false

func coinsCollected():
	Game.Coin += 10
	var pop = POP.instantiate()
	add_child(pop)
	pop.show_value(str(10),false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("units"):
		fixing_counter = 5
		unit_nearby=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("units"):
		unit_nearby=false

func _on_increase_button_down():
	if production_rate < max_production:
		production_rate += 1

func _on_decrease_button_down() -> void:
	if production_rate > 0 :
		production_rate -= 1

func connect_pump(val,query=false):
	if query:
		return connected
	else:
		connected = val

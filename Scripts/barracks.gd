extends StaticBody2D

var totalTime = 5
var currTime 
var units = 0
var go_fix : bool =false
@export var bar : ProgressBar
@export var timer : Timer
var body_entered
var production_rate = 0
var window
@export var is_pump : bool 
@export var fan : Sprite2D
@export var age_bar : ProgressBar
@export var increase_button : Button
@export var decrease_button : Button
@export var stop_button : Button
@export var accelerate_button : Button
@export var max_production = 10
@export var production_step = 1
@export var production_rate_bar : ProgressBar
var fixable : bool = false
var unit_nearby : bool = false
var POP = preload("res://Global/pop.tscn")
var mouseEntered = false
@export var select : Panel
var selected = false
var building_cursor_icon  = load("res://assets/building_cursor.png")
var counter : float = 0.0
@export var initial_age : int = 1000
var age = 1000
@export var age_label : Label
@export var connected : bool = false
var fixing_counter : float = 0
var fixing_time : float = 5
@export var select_value : Label
var outlet : bool = false
var inlet : bool = false
var inlet_source 
@export var cost_label : Label
var UI


func _ready() -> void:
	UI = get_parent().get_node("UI")
	cost_label.visible = false
	inlet_source = null
	currTime = totalTime
	if bar :
		bar.max_value = fixing_time
		bar.visible=false
		bar.value = 0
	age = initial_age
	age_bar.max_value = initial_age
	production_rate_bar.max_value = max_production

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cost_label.visible :
		cost_label.global_position = get_global_mouse_position()
	select_value.text = str(select)
	select.visible = selected

	if bar :
		bar.value = currTime
	if currTime <= 0 :
		body_entered.add_rank(1)
		treeChopped()
		currTime = totalTime
	if fixing_counter > 0 :
		fixing_counter -= delta
		if unit_nearby and fixing_counter <= 0 :
			age = initial_age
			fixable = false
	if !outlet or !inlet :
		production_rate = 0
	counter += production_rate
	if counter > 500 and age > 0:
		coinsCollected(10)
		counter = 0
	if production_rate > 0 :
		age -= 0.02*production_rate
		if inlet_source != null :
			inlet_source.reduce_level(true)
	elif production_rate <= 0 :
		if inlet_source != null :
			inlet_source.reduce_level(false)
	if go_fix and unit_nearby:
		
		go_fix = false
		startChopping()
	if inlet_source:
		if age <= 0 or inlet_source.return_level() <= 0:
			production_rate = 0
		age_label.text = "RUL : " + str(age)
		age_bar.value = age
		production_rate_bar.value = production_rate
		increase_button.visible = selected
		decrease_button.visible = selected
		production_rate_bar.visible = selected
		stop_button.visible = selected
		accelerate_button.visible = selected
		fan.rotation += round(production_rate*10)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		if fixable :
			go_fix = true
	if event.is_action_pressed("LeftClick"):
		if mouseEntered :
			selected = true
		if !mouseEntered:
			selected = false

func _on_mouse_entered() -> void:
	mouseEntered = true
	if Game.unit_selected == "technician" and age < initial_age and Game.selected_body.return_carrying() and Game.Gold >= 100 :
		#print("should be YES mouseEntered ", mouseEntered)
		cost_label.text = "-100G"
		cost_label.visible = true
		Input.set_custom_mouse_cursor(building_cursor_icon)
		fixing_counter = fixing_time
		fixable = true

	if Game.unit_selected == "technician" and age < initial_age and Game.selected_body.return_carrying() and Game.Gold < 101 :
		UI.Gold.modulate.a = 0.5

func _on_mouse_exited() -> void:
	mouseEntered = false
	cost_label.visible = false
	Input.set_custom_mouse_cursor(null)
	fixable = false

func coinsCollected(val):
	Game.Production += val
	var pop = POP.instantiate()
	add_child(pop)
	pop.show_value(str(val),false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("units"):
		body.stop_moving()
		body.anim.play("Walk Down")
		body_entered = body
		unit_nearby=true
		units += 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("units"):
		body_entered = null
		unit_nearby=false
		units -= 1
		if units  <= 0 :
			timer.stop()

func _on_increase_button_down():
	selected = true
	if production_rate < max_production and age > 0:
		production_rate += production_step

func _on_decrease_button_down() -> void:
	selected = true
	if production_rate > 0 and age > 0 :
		production_rate -= production_step

func _on_timer_timeout() :
	var chopSpeed = 1*units
	currTime -= chopSpeed
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value",currTime,0.5).set_trans(Tween.TRANS_LINEAR)

func startChopping():
	bar.visible=true
	timer.start()

func treeChopped():
	if body_entered.picked_up_object != null:
		Game.Wood += 1
		age = initial_age
		Game.Gold -= 100
		bar.visible=false
		body_entered.picked_up_object.queue_free()

func _on_stop_button_down() -> void:
	selected = true
	if age > 0 :
		production_rate = 0

func _on_accelerate_button_down() -> void:
	selected = true
	if age > 0 :
		production_rate = max_production

func _on_outlet_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("inlet"):
		outlet = true

func _on_outlet_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("inlet"):
		outlet = false

func _on_inlet_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("outlet"):
		print("there is an area")
		inlet = true
		print(area.get_parent())
		if area.get_parent().is_in_group("tank"):
			inlet_source = area.get_parent()
			print("there is a tank")

func _on_inlet_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("outlet"):
		inlet = false
		if area.get_parent().is_in_group("tank"):
			inlet_source = null

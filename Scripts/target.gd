extends RigidBody2D
var mouseEntered : bool = false
var health : int = 5
@export var health_bar : ProgressBar
@export var splash : CPUParticles2D
@export var labelee : Label
var attacking_cursor_icon  = load("res://assets/axe.png")
var targeted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_bar.value = health
	labelee.text = str(mouseEntered)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick") and Game.unit_selected == "technician" :
		if mouseEntered:
			targeted = true
		if !mouseEntered:
			targeted= false

	if event.is_action_pressed("RightClick") and get_parent().units != []:
		var units = get_parent().units
		for unit in units:
			if unit.selected :
				if mouseEntered and targeted :
					unit.hunt(self)
				elif !mouseEntered:
					unit.hunt(null)
					


func _on_mouse_entered() -> void:
	print("target is found!")
	if Game.unit_selected == "technician":
		mouseEntered = true
		Input.set_custom_mouse_cursor(attacking_cursor_icon)


func _on_mouse_exited() -> void:
	mouseEntered = false
	Input.set_custom_mouse_cursor(null)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet") and health > 0 :
		splash.emitting = true
		body.queue_free()
		if health == 1 :
			Game.Gold += 100
			queue_free()
		else : 
			health -= 1



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bullet") and health > 0 :
		body.queue_free()
		if health == 1 :
			queue_free()
		else : 
			health -= 1

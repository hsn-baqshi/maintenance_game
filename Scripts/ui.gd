extends CanvasLayer

@export var label : Label
@export var Gold : Label
@export var Production : Label
@export var Price : Button
@export var amount : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#label.text = "Wood : " + str(Game.Wood)
	Gold.text = "Gold : " + str(Game.Gold) 
	Production.text = "Production : " + str(Game.Production) + " L"
	Price.text = "Sell : " + str(amount) + "L @"+ str(Game.Profit_margin) + " $/L , GAIN +" + str(amount*Game.Profit_margin)
func _on_button_button_down() -> void:
	if Game.Production >= amount :
		Game.Production -= amount
		Game.Gold += amount*Game.Profit_margin

func _on_increase_button_down() -> void:
	amount += 1


func _on_decrease_button_down() -> void:
	amount -= 1

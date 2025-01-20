extends CanvasLayer

@export var label : Label
@export var Gold : Label
@export var Production : Label
@export var Price : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#label.text = "Wood : " + str(Game.Wood)
	Gold.text = "Gold : " + str(Game.Gold) 
	Production.text = "Production : " + str(Game.Production) + " L"
	Price.text = "Sell : " + str(Game.Profit_margin) + " $/L"


func _on_button_button_down() -> void:
	if Game.Production >= 1 :
		Game.Production -= 1
		Game.Gold += Game.Profit_margin
		

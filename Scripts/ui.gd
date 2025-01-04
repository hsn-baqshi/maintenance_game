extends CanvasLayer

@export var label : Label
@export var Gold : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Wood : " + str(Game.Wood)
	Gold.text = "Gold : " + str(Game.Gold)

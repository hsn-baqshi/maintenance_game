extends StaticBody2D

var POP = preload("res://Global/pop.tscn")

var totalTime = 50
var currTime

@export var bar : ProgressBar
@export var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currTime = totalTime
	bar.max_value = totalTime
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currTime <= 0 :
		coinsCollected()


func _on_timer_timeout() -> void:
	currTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value",currTime,0.1).set_trans(Tween.TRANS_LINEAR)
	

func coinsCollected():
	Game.Coin += 10
	_ready()
	var pop = POP.instantiate()
	add_child(pop)
	pop.show_value(str(10),false)

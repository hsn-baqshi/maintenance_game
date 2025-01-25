extends StaticBody2D

@export var level_bar : ProgressBar
var level : float = 10
var reduce : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level_bar.value = level
	if reduce and level > 0:
		level -= delta
		if level <= 0 :
			level = 0
func reduce_level(val):
	reduce = val

func return_level():
	return level

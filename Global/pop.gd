extends Label

var travel = Vector2(0,-50)
var duration = 1
var spread = PI/2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_value(value,crit):
	var tween = create_tween()
	text = "+ " + str(value) + "g"
	pivot_offset = size / 4
	
	var movement = travel.rotated(randi_range(-spread/2,spread/2))
	
	tween.tween_property(self,"position",position + movement, duration)
	tween.tween_property(self,"modulate:a",0, duration)
	
	if crit:
		modulate = Color(1,0,0)
		scale = scale*2
		tween.tween_property(self,"scale",scale,0.4)
		
	tween.play()
	tween.tween_callback(self.queue_free)
		

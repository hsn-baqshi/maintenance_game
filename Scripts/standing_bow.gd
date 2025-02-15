extends StaticBody2D
@export var splash : CPUParticles2D
@export var spritee : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().add_child(splash)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_bow(val):
	splash.emitting = true
	spritee.visible = false
	val.equipment.append("bow")
	await get_tree().create_timer(1).timeout
	queue_free()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("technician"):
		print("bow is taken!")
		var is_bow = false
		if body.equipment == []:
			add_bow(body)	
		else:
			for i in body.equipment :
				print("I am in the loop")
				if i == "bow" :
					is_bow = true
			if !is_bow :
				add_bow(body)

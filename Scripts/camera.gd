extends Camera2D

#camera control

@export var speed = 20.0
@export var zoom_speed = 20
@export var zoom_margin = 0.1
@export var zoom_min = 0.5
@export var zoom_max = 3.0
var zoomFactor = 1
var zoomPos = Vector2()
var zooming = false

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
signal area_selected
signal start_move_selection
@export var panelarea : Panel 

func _ready():
	#print(panelarea.global_position)
	connect("area_selected",Callable(get_parent(),"_on_area_selected"))

func _process(delta):
	
	var inputX = int( Input.is_action_pressed("ui_right") ) - int( Input.is_action_pressed("ui_left") )
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	position.x = lerp(position.x, position.x + inputX*speed*zoom.x, speed*delta)
	position.y = lerp(position.y, position.y + inputY*speed*zoom.y, speed*delta)
	
	zoom.x = lerp(zoom.x,zoom.x*zoomFactor, zoom_speed*delta)
	zoom.y = lerp(zoom.y,zoom.y*zoomFactor, zoom_speed*delta)
	
	zoom.x = clamp(zoom.x, zoom_min,zoom_max)
	zoom.y = clamp(zoom.y, zoom_min,zoom_max)
	
	if not zooming:
		zoomFactor = 1.0
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
		
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20 :
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected",self)
		else:
			end = start
			isDragging = false
			draw_area(false)
			
func _input(event):
	
	#### ZOOMING START #####
	if (abs(zoomPos.x - get_global_mouse_position().x ) > zoom_margin):
		zoomFactor=1
	if (abs(zoomPos.y - get_global_mouse_position().y ) > zoom_margin):
		zoomFactor=1
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("WheelDown"):
				zoomFactor -= 0.01*zoom_speed
				zoomPos = get_global_mouse_position()
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("WheelUp"):
				zoomFactor += 0.01*zoom_speed
				zoomPos = get_global_mouse_position()
		else:
			zooming = false
	#### ZOOMING START #####
	
	
	if event is InputEventMouse :
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()

func draw_area(s=true):
	panelarea.size = Vector2(abs(startV.x - endV.x),abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	panelarea.position = pos
	panelarea.size *= int(s)
	#print("the panel pos is ",panelarea.global_position)

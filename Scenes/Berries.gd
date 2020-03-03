extends StaticBody2D

signal clicked
var food = 2
var selectable = false
var mouse_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if food <= 0:
		queue_free()
		
	if mouse_over and selectable:
		$select.visible = true
	else:
		$select.visible = false
func deplete():
	food -= 1
	return 1
	

func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Click pressed")
			emit_signal("clicked", self)
		else:
			print("Click released")

func _on_Clickable_mouse_entered():
	mouse_over = true
	
func _on_Clickable_mouse_exited():
	mouse_over = false

extends StaticBody2D


signal clicked
var wood = 10
var selectable = false
var mouse_over = false

func _process(delta):
	if wood <= 0:
		queue_free()
		
	if mouse_over and selectable:
		$select.visible = true
	else:
		$select.visible = false
func deplete():
	wood -= 2
	return 2
	

func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("clicked", self)



func _on_Clickable_mouse_entered():
	mouse_over = true
	



func _on_Clickable_mouse_exited():
	mouse_over = false

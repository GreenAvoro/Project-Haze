extends StaticBody2D

var wood = 10
var selectable = false
var mouse_over = false
func _process(delta):
	if wood <= 0:
		queue_free()
		
	if selectable and mouse_over:
		$select.visible = true
	else:
		$select.visible = false
func deplete():
	wood -= 2
	return 2
	
func click(player):
	player.chop_wood()
	
#Called when animation finishes
func finish(player):
	player.wood += deplete()
	player.interacting = null
func _on_Clickable_mouse_entered():
	mouse_over = true
	if has_node("/root/Overworld/Player"):
		get_node("/root/Overworld/Player").clickable_object_enter(self)
	else:
		print("Can't find tree!")
	
func _on_Clickable_mouse_exited():
	mouse_over = false
	if has_node("/root/Overworld/Player"):
		get_node("/root/Overworld/Player").clickable_object_exit(self)
	else:
		print("Can't find tree!")

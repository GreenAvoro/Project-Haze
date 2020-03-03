extends Node2D

var fuel = 20
const FUEL_DEPLETION = 0.5
signal clicked
var selectable = false
var mouse_over = false
var bodies_present = []

func _process(delta):
	if fuel > 0:
		fuel -= FUEL_DEPLETION * delta
		$Light.enabled = true
	if fuel < 0:
		fuel = 0
		$Light.enabled = false
		
	for body in bodies_present:
		if fuel > 0:
			body.warm = true
		else:
			body.warm = false
		
		
	if mouse_over and selectable:
		$select.visible = true
	else:
		$select.visible = false
	
func add_fuel(p):
	fuel += p.wood
	p.wood = 0


func _on_Clickable_mouse_entered():
	mouse_over = true


func _on_Clickable_mouse_exited():
	mouse_over = false


func _on_Clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Click pressed")
			emit_signal("clicked", self)
		else:
			print("Click released")


func _on_Warmth_body_entered(body):
	if body.name == "Player":
		bodies_present.append(body)
		


func _on_Warmth_body_exited(body):
	for bod in bodies_present:
		if bod == body:
			body.warm = false
			bodies_present.pop_back()
			break

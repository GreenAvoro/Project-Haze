extends KinematicBody2D

const SPEED = 5000
var move = Vector2()
var stopped = false
var wood = 0
var food = 0
var warm = false
var warmth = 30
var hunger = 30
const HUNGER_DEPLETION = 0.1
const WARMTH_DEPLETION = 0.5
var within_reach = []
var talk_to = null

func _process(delta):
	$Debug/Panel/Wood.text = "Wood: " + str(wood)
	$Debug/Panel/Warmth.text = "Warmth: " + str(stepify(warmth, 0.1))
	$Debug/Panel/Food.text = "Food: " + str(food)
	$Debug/Panel/Time.text = "Time: " + str(int(get_parent().time))
	$Debug/Panel/Hunger.text = "Hunger: " + str(stepify(hunger, 0.1))
	$Debug/Panel/Day.text = "Day: " + str(int(get_parent().day))
	$Debug/Panel/X.text = "X: " + str(position.x)
	$Debug/Panel/Y.text = "Y: " + str(position.y)
	if warm:
		warmth += WARMTH_DEPLETION * delta
	else:
		warmth -= WARMTH_DEPLETION * delta
	hunger -= HUNGER_DEPLETION * delta
func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_interact"):
		if talk_to != null:
			var speech = talk_to.talk()
			if speech == "---end":
				talk_to.stopped = false
				$Debug/Dialogue.visible = false
			else:
				talk_to.stopped = true
				$Debug/Dialogue.visible = true
				$Debug/Dialogue/MarginContainer/VCont/Name.text = talk_to.char_name
				$Debug/Dialogue/MarginContainer/VCont/Speech.text = speech		
	if !stopped:
		if Input.is_action_pressed("ui_left"):
			move.x = -1
			$AnimatedSprite.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			move.x = +1
			$AnimatedSprite.flip_h = false
			
		else:
			move.x = 0
		if Input.is_action_pressed("ui_up"):
			move.y = -1
		elif Input.is_action_pressed("ui_down"):
			move.y = +1
		else:
			move.y = 0
		if move.x != 0 or move.y != 0:
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.playing = true
		else:
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.playing = false
		
		move = move.normalized() * SPEED
			
		move_and_slide(move * delta)

func add_wood(body):
	#Connects to Tress to chop wood and add it to self
	wood += body.deplete()
func add_food(body):
	food += body.deplete()
func interact_fireplace(fireplace):
	
	fireplace.add_fuel(self)

	
func _on_Reach_area_entered(area):
	if area.is_in_group("selectable"):
		within_reach.append(area)
		area.get_parent().selectable = true
		if area.is_in_group("trees"):
			area.get_parent().connect("clicked",self, "add_wood")
		elif area.is_in_group("food"):
			area.get_parent().connect("clicked", self, "add_food")
		elif area.get_parent().name == "Fireplace":
			area.get_parent().connect("clicked", self, "interact_fireplace")
	
	elif area.is_in_group("npc"):
		talk_to = area.get_parent()
		area.get_parent().interact = true
		


func _on_Reach_area_exited(area):
	if area.get_parent() == talk_to:
		talk_to.stopped = false
		talk_to = null
		$Debug/Dialogue.visible = false
		area.get_parent().interact = false
	var filtered = []
	for item in within_reach:
		if area == item:
			area.get_parent().selectable = false
			if area.is_in_group("trees"):
				area.get_parent().disconnect("clicked",self, "add_wood")
			elif area.is_in_group("food"):
				area.get_parent().disconnect("clicked", self, "add_food")
			elif area.get_parent().name == "Fireplace":
				area.get_parent().disconnect("clicked", self, "interact_fireplace")
			break
		else:
			filtered.append(item)
	within_reach = filtered

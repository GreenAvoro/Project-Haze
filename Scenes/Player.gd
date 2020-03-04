extends KinematicBody2D

const SPEED = 5000
var move = Vector2()
var stopped = false
var facing = "down"
var wood = 0
var food = 0
var warm = false
var warmth = 30
var hunger = 30
const HUNGER_DEPLETION = 0.1
const WARMTH_DEPLETION = 0.5
var within_reach = []
var talk_to = null
var objects_clickable = []
var interacting = null

	
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
				stopped = false
			else:
				talk_to.stopped = true
				$Debug/Dialogue.visible = true
				$Debug/Dialogue/MarginContainer/VCont/Name.text = talk_to.char_name
				$Debug/Dialogue/MarginContainer/VCont/Speech.text = speech		
				stopped = true
	if !stopped:
		if Input.is_action_just_pressed("ui_left_click"):
			for item in within_reach:
				if objects_clickable.has(item):
					item.click(self)
					interacting = item
					return
					#Rest of input is skipped because otherwise
					#	it resets animation
		
		if Input.is_action_pressed("ui_left"):
			facing = "left"
			move.x = -1
		elif Input.is_action_pressed("ui_right"):
			facing = "right"
			move.x = +1
			
		else:
			move.x = 0
		if Input.is_action_pressed("ui_up"):
			facing = "up"
			move.y = -1
		elif Input.is_action_pressed("ui_down"):
			facing = "down"
			move.y = +1
		else:
			move.y = 0
			
			
		if move.x != 0:
			if facing == "left":
				$AnimatedSprite.play("run_left")
			elif facing == "right":
				$AnimatedSprite.play("run_right")
		elif move.y != 0:
			if move.y > 0:
				$AnimatedSprite.play("run_down")
			else:
				$AnimatedSprite.play("run_up")
		if move.y == 0 and move.x == 0:
			if facing == "left":
				$AnimatedSprite.play("idle_left")
			elif facing == "right":
				$AnimatedSprite.play("idle_right")
			elif facing == "up":
				$AnimatedSprite.play("idle_up")
			elif facing == "down":
				$AnimatedSprite.play("idle_down")
		
		move = move.normalized() * SPEED
			
		move_and_slide(move * delta)

func clickable_object_enter(tree):
	objects_clickable.append(tree)

func clickable_object_exit(tree):
	for i in range(objects_clickable.size()-1,-1,-1):
		if objects_clickable[i] == tree:
			objects_clickable.remove(i)

#Called from Tree objects
func chop_wood():
	stopped = true
	$AnimatedSprite.stop()
	$AnimatedSprite.play("chop")
func _on_Reach_area_entered(area):
	if area.get_parent().is_in_group("selectable"):
		within_reach.append(area.get_parent())
		area.get_parent().selectable = true

	elif area.get_parent().is_in_group("npc"):
		talk_to = area.get_parent()
		area.get_parent().interact = true
	print(within_reach)
		


func _on_Reach_area_exited(area):
	if area.get_parent() == talk_to:
		talk_to.stopped = false
		talk_to = null
		$Debug/Dialogue.visible = false
		area.get_parent().interact = false
	var filtered = []
	for item in within_reach:
		if area.get_parent() == item:
			area.get_parent().selectable = false
		else:
			filtered.append(item)
	within_reach = filtered



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "chop":
		stopped = false
		if interacting != null:
			interacting.finish(self)
		

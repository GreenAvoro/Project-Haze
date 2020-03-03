extends KinematicBody2D

const DISTANCE_THRESHOLD = 3.0
export var MAX_SPEED = 50

export var char_name = "Gabe"

var _velocity = Vector2.ZERO
export var slow_radius = 50
export var move_energy = 50

#move_freq: Every seconds(int), think about moving.
export var move_freq = 10
var move_timer = rand_range(0, move_freq)
onready var target_global_pos = global_position
var moving = false
var interact = false
var dialogue = {}
var speech_flag = 1
var stopped = false

func _ready():
	# Check if there is a classes file
	var file = File.new()
	if not file.file_exists("res://resources/npc_dialogue.json"):
		print("Missing classes.json file.")
	else:
		file.open("res://resources/npc_dialogue.json", File.READ)
		var text = file.get_as_text()
		var parsed = JSON.parse(text).result
		dialogue = parsed[char_name]
		file.close()
		

func _process(delta):
	if interact:
		$SpeechBubble.visible = true
		$SpeechBubble.playing = true
	else:
		$SpeechBubble.visible = false
		$SpeechBubble.playing = false
		
	$Pos.text = "X: " + str(position.x) + "Y: " + str(position.y)
func _physics_process(delta):
	if !stopped:
		if move_timer >= move_freq:
			target_global_pos = pick_direction(move_energy)
			moving = true
			move_timer = 0
		if global_position.distance_to(target_global_pos) < DISTANCE_THRESHOLD:
			moving = false
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.playing = false
		if moving:
			move_to(target_global_pos)
			if _velocity.x < 0:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.playing = true
			_velocity = move_and_slide(_velocity)
		else:
			move_timer += delta
func move_to(target_pos):
	_velocity = steering.arrive_to(
		_velocity,
		global_position,
		target_pos,
		MAX_SPEED,
		slow_radius
		)
func pick_direction(energy):
	var x = rand_range(-energy, energy)
	var y = rand_range(-energy, energy)
	var pos = global_position
	return Vector2(pos.x+x,pos.y+y)
func talk():
	if str(speech_flag) == "---end":
		speech_flag = -1
		return "---end"
	var speech_to_return = dialogue[str(speech_flag)]["speech"]
	speech_flag = dialogue[str(speech_flag)]["flag"]
	return speech_to_return
	


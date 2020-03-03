extends KinematicBody2D

const DISTANCE_THRESHOLD = 3.0
export var MAX_SPEED = 50

var _velocity = Vector2.ZERO
export var slow_radius = 100
export var move_energy = 10

#move_freq: Every seconds(int), think about moving.
export var move_freq = 10
var move_timer = rand_range(0, move_freq)
onready var target_global_pos = global_position
var moving = false

func _physics_process(delta):
	if move_timer >= move_freq:
		target_global_pos = pick_direction(move_energy)
		moving = true
		move_timer = 0
	if global_position.distance_to(target_global_pos) < DISTANCE_THRESHOLD:
		moving = false
	if moving:
		_velocity = steering.arrive_to(
			_velocity,
			global_position,
			target_global_pos,
			MAX_SPEED,
			slow_radius
		)
		_velocity = move_and_slide(_velocity)
	move_timer += delta
	
func pick_direction(energy):
	var x = rand_range(-energy, energy)
	var y = rand_range(-energy, energy)
	var pos = global_position
	return Vector2(pos.x+x,pos.y+y)

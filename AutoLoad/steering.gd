extends Node

const DEFAULT_MASS = 2
const DEFAULT_MAX_SPEED = 400
const DEFAULT_SLOW_RADIUS = 100

static func follow(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed = DEFAULT_MAX_SPEED,
	mass = DEFAULT_MASS
	) -> Vector2:
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	var steer = (desired_velocity - velocity) / mass
	return velocity + steer
	
#Node will slow down upon approaching target	
static func arrive_to(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed = DEFAULT_MAX_SPEED,
	slow_radius = DEFAULT_SLOW_RADIUS,
	mass = DEFAULT_MASS
	) -> Vector2:
	var to_target = global_position.distance_to(target_position)
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	if to_target < slow_radius:
		desired_velocity *= (to_target / slow_radius) * 0.8 + 0.2
	var steer = (desired_velocity - velocity) / mass
	return velocity + steer

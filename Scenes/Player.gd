# Got this code from https://kidscancode.org/godot_recipes/2d/car_steering/ as a starter
extends KinematicBody2D

signal player_stopped

export var wheel_base = 70  # Distance from front to rear wheel. Original: 70
export var steering_angle = 15  # Amount that front wheel turns, in degrees. Original: 70
export var engine_power = 800 # Forward acceleration force. Original: 800 
export var braking = -450 # Original: -450
export var max_speed_reverse = 250 # Original: 250
export var friction = -0.9 # Friction is proportional to velocity. Original: -0.9
export var drag = -0.0015 # drag is the result of wind resistance. Proportional to the velocity squared. Original: -0.0015
export var slip_speed = 400 # Speed where traction is reduced. Original: 400
# If traction were 1.0, we would have no sliding
export var traction_fast = 0.1 # High-speed traction. Original: 0.1
export var traction_slow = 0.7 # Low-speed traction. Original: 0.7

var velocity = Vector2.ZERO # track overall velocity
var steer_angle
var acceleration = Vector2.ZERO # track overall acceleration
var stopped = false # track if car is not moving









func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	check_if_stopped()
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_angle = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking

	
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	# Adding traction
	var traction = traction_slow
	if velocity .length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
func check_if_stopped():
	if (is_zero_approx(velocity.length())):
		stopped = true
	else:
		stopped = false
		
		
	
	


	
	


func _on_pickup_area_body_entered(body):
	print("Player enetered pick up zone!")
	

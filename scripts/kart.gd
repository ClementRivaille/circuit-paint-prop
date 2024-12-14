extends CharacterBody2D
class_name Kart

@export var max_velocity: float = 10
@export var max_backward_celocity: float = 50
@export var accel: float = 1
@export var steer_force: float = 10
@export var deceleration :float = 0.9

@onready var camera: Camera2D = $Camera2D

var current_speed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("steer_left") || Input.is_action_pressed("steer_right")):
		var steering :float = min(steer_force, steer_force * current_speed / (max_velocity / 2)) * delta
		steering *= 1 if Input.is_action_pressed(("steer_right")) else -1
		rotate(steering)

	if (Input.is_action_pressed("accelerate") || Input.is_action_pressed("brake")):
		current_speed += delta * (accel if Input.is_action_pressed("accelerate") else -accel)
		current_speed = clamp(current_speed, -max_backward_celocity, max_velocity)
	elif abs(current_speed) > 0:
		if abs(current_speed) > deceleration * delta:
			var deceleration_force :float= delta * deceleration * (-1 if current_speed > 0 else 1)
			current_speed += deceleration_force
		else:
			current_speed = 0

	var rotation := get_rotation()
	var direction := Vector2.from_angle(rotation - PI / 2)
	velocity = direction * current_speed
	move_and_slide()

	if is_on_wall():
		on_collide()

func on_collide():
	var speed_direction := -1 if get_real_velocity().rotated(get_rotation()).y > 0 else 1
	current_speed = get_real_velocity().length() * speed_direction

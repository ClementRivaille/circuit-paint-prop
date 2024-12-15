extends CharacterBody2D
class_name Kart

@export var max_velocity: float = 10
@export var max_backward_celocity: float = 50
@export var accel: float = 1
@export var steer_force: float = 10
@export var deceleration :float = 0.9
@export var icy_deceleration := 1.0
@export var wet_max_velocity := 0.005
@export var velocity_change_duration := 0.6

@onready var camera: Camera2D = $Camera2D
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var sfx: KartSFX = $KartSFX

var current_speed := 0.0
var active := false
var engine_stopped := false
var velocity_limit := 50.0

var last_cell_visited := Vector2i(0,0)
var on_ice := false
var on_water := false

var velocity_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate()
	GameStore.mode_changed.connect(on_change_mode)
	GameStore.goal_reached.connect(stop_engines)
	velocity_limit = max_velocity

func activate():
	global_position = GameStore.get_global_position(GameStore.start_position)
	visible = true
	camera.make_current()
	sfx.start_engine()

	current_speed = 0.0
	var goal_position := GameStore.get_global_position(GameStore.goal_position)
	rotation = global_position.angle_to_point(goal_position) + PI/2
	velocity_limit = max_velocity
	update_cell_position()

	engine_stopped = false
	active = true

func deactivate():
	visible = false
	collision.disabled = true
	position = Vector2(-10,-10)
	active = false
	on_ice = false
	on_water = false
	sfx.stop_engine()

func on_change_mode(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		activate()
	elif active:
		deactivate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active: return

	if collision.disabled:
		collision.disabled = false

	update_cell_position()

	if (Input.is_action_pressed("steer_left") || Input.is_action_pressed("steer_right")):
		var steering :float = min(steer_force, steer_force * current_speed / (max_velocity / 2)) * delta
		steering *= 1 if Input.is_action_pressed(("steer_right")) else -1
		rotate(steering)

	var deceleration_value := icy_deceleration if on_ice else deceleration
	var backward_velocity_limit = min(velocity_limit, max_backward_celocity)
	if (Input.is_action_pressed("accelerate") || Input.is_action_pressed("brake")) && !engine_stopped:
		var speed_gain := delta * (accel if Input.is_action_pressed("accelerate") else -accel)
		if speed_gain < 0 && current_speed > 0 && on_ice:
			speed_gain = speed_gain / 3
		current_speed += delta * (accel if Input.is_action_pressed("accelerate") else -accel)
		current_speed = clamp(current_speed, -backward_velocity_limit, velocity_limit)
	elif abs(current_speed) > 0:
		if abs(current_speed) > deceleration_value * delta:
			var deceleration_force :float= delta * deceleration_value * (-1 if current_speed > 0 else 1)
			current_speed += deceleration_force
		else:
			current_speed = 0

	var car_rotation := get_rotation()
	var direction := Vector2.from_angle(car_rotation - PI / 2)
	velocity = direction * current_speed
	move_and_slide()

	if is_on_wall():
		on_collide()

	sfx.update_velocity(get_real_velocity().length())

func on_collide():
	sfx.play_collide(current_speed)
	var speed_direction := -1 if get_real_velocity().rotated(get_rotation()).y > 0 else 1
	current_speed = get_real_velocity().length() * speed_direction

func stop_engines():
	engine_stopped = true

func update_cell_position():
	var current_cell := GameStore.get_position_on_map(global_position)
	if current_cell != last_cell_visited:
		last_cell_visited = current_cell

		on_ice = GameStore.read_cell_flag(current_cell, "ice")
		var water := GameStore.read_cell_flag(current_cell, "slow")

		if on_water != water:
			on_water = water
			if velocity_tween && velocity_tween.is_running:
				velocity_tween.kill()
			velocity_tween = create_tween()
			velocity_tween.tween_property(self, "velocity_limit",
				wet_max_velocity if on_water else max_velocity, velocity_change_duration
				).set_trans(Tween.TRANS_SINE
				).set_ease(Tween.EASE_IN_OUT)

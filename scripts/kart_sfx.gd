extends AudioStreamPlayer
class_name KartSFX

@export var volume_engine_max := 0
@export var volume_engine_min := -10
@export var lowest_pitch := 0.01
@export var highest_pitch := 1.0
@export var max_velocity := 50.0
@export var volume_progression: Curve
@export var collision_interval_min := 0.6
@export var collision_min_speed := 10.0

@onready var collisionSFX: AudioStreamPlayer = $collision

var collision_locked := false

func start_engine():
	update_velocity(0)
	play()

func update_velocity(velocity: float):
	var force = min(1.0, abs(velocity) / max_velocity)

	pitch_scale = lerp(lowest_pitch, highest_pitch, force)

	var volume_level = volume_progression.get_point_position(force)
	volume_db = lerp(volume_engine_min, volume_engine_max, volume_level)

func stop_engine():
	stop()

func play_collide(speed: float):
	if speed < collision_min_speed || collision_locked: return
	collisionSFX.pitch_scale = lerpf(0.9, 1.1, randf())
	collisionSFX.play()
	collision_locked = true
	await get_tree().create_timer(collision_interval_min).timeout
	collision_locked = false

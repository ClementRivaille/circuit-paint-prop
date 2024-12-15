extends Node2D
class_name Chrono

var active := false
var time_start := 0

func _ready() -> void:
	GameStore.start_race.connect(start)
	GameStore.mode_changed.connect(on_mode_change)
	GameStore.goal_reached.connect(stop)

func _physics_process(delta: float) -> void:
	if active:
		var delta_time := Time.get_ticks_msec() - time_start
		GameStore.set_chrono_time(delta_time)

func start():
	time_start = Time.get_ticks_msec()
	active = true

func on_mode_change(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		GameStore.reset_chrono_time()
	elif active:
		stop()

func stop():
	active = false

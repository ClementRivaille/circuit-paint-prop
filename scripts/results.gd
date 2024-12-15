extends Control
class_name Results

@onready var time: Label = $Time

func _ready() -> void:
	visible = false
	GameStore.mode_changed.connect(on_screen_change)

func on_screen_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.RESULTS
	if visible:
		time.text = ChronoDisplay.format_time(GameStore.chrono_time)

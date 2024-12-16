extends Control
class_name Results

@onready var time: Label = $Time
@onready var nextLevelBtn: Control = $NextLevelBtn
@onready var endBtn: Control = $EndBtn

func _ready() -> void:
	visible = false
	GameStore.mode_changed.connect(on_screen_change)

func on_screen_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.RESULTS
	if visible:
		time.text = ChronoDisplay.format_time(GameStore.chrono_time)
		var has_next_level := GameStore.level_idx + 1 < GameStore.total_levels
		nextLevelBtn.visible = has_next_level
		endBtn.visible = !has_next_level

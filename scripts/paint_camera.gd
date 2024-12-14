extends Camera2D
class_name PaintCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.mode_changed.connect(on_mode_change)

func on_mode_change(mode: Store.GameMode):
	if mode != Store.GameMode.RACING:
		make_current()

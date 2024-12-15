extends Control
class_name Toolkit

func _ready() -> void:
	visible = true
	GameStore.mode_changed.connect(on_screen_change)

func on_screen_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.PAINTING

extends Control

func _ready() -> void:
	GameStore.mode_changed.connect(on_mode_change)
	visible = false

func on_mode_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.RACING

func _input(event: InputEvent) -> void:
	if GameStore.current_mode == Store.GameMode.RACING && event.is_action_pressed("exit"):
		GameStore.change_mode(Store.GameMode.PAINTING)

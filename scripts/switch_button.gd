extends Control
class_name SwitchButton

@export var to_mode := Store.GameMode.RACING

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed():
		GameStore.reset_checkpoints()
		GameStore.change_mode(to_mode)

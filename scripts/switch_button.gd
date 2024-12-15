extends Control
class_name SwitchButton

@export var to_mode := Store.GameMode.RACING
@export var next_level := false

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed():
		if next_level:
			GameStore.next_level()
		GameStore.change_mode(to_mode)

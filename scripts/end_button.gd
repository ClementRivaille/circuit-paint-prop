extends Control
class_name EndButton

@export var to_mode := Store.GameMode.RACING
@export var next_level := false

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed():
		GameStore.end_game()

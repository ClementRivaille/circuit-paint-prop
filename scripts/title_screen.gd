extends Control
class_name TitleScreen

func start_game():
	GameStore.next_level()
	GameStore.change_mode(Store.GameMode.PAINTING)
	visible = false

func _on_start_btn_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		start_game() # Replace with function body.

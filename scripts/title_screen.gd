extends Control
class_name TitleScreen

@onready var thanks: Label = $Thanks

func _ready() -> void:
	thanks.visible = false
	GameStore.mode_changed.connect(on_mode_change)

func start_game():
	GameStore.next_level()
	GameStore.change_mode(Store.GameMode.PAINTING)

func _on_start_btn_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		start_game() # Replace with function body.

func on_mode_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.TITLE
	thanks.visible = true

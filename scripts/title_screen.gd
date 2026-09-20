extends Control
class_name TitleScreen

@onready var thanks: Label = $Thanks
@onready var random_btn: Control = $StartRandom

func _ready() -> void:
	thanks.visible = false
	random_btn.visible = false
	GameStore.mode_changed.connect(on_mode_change)
	GameStore.save_loaded.connect(on_save_loaded)

func start_game():
	GameStore.next_level()
	GameStore.change_mode(Store.GameMode.PAINTING)

func start_randomized():
	GameStore.start_random()
	GameStore.change_mode(Store.GameMode.PAINTING)

func _on_start_btn_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		start_game()

func _on_random_btn_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		start_randomized()

func on_mode_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.TITLE
	thanks.visible = true
	random_btn.visible = true

func on_save_loaded(save: GameSave) -> void:
	random_btn.visible = save.finished_game

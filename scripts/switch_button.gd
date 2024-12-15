extends Control
class_name SwitchButton

@export var to_mode := Store.GameMode.RACING
@export var next_level := false
@export var disable_color: Color

@onready var instructions: Label = $Instructions

var enabled := false

func _ready() -> void:
	GameStore.start_validated.connect(on_validation)
	GameStore.goal_validated.connect(on_validation)
	GameStore.checkpoint_validated.connect(func (_index, valid): on_validation(valid))
	GameStore.mode_changed.connect(on_mode_change)
	enabled = to_mode != Store.GameMode.RACING

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed() && enabled:
		GameStore.reset_checkpoints()
		if next_level:
			GameStore.next_level()
		GameStore.change_mode(to_mode)

func enable(value: bool):
	enabled = value
	modulate = Color.WHITE if enabled else disable_color
	instructions.visible = value

func on_validation(valid: bool):
	if to_mode == Store.GameMode.RACING:
		enable(valid && GameStore.are_item_placed())

func on_mode_change(mode: Store.GameMode):
	if (mode == Store.GameMode.PAINTING && to_mode == Store.GameMode.RACING):
		enable(GameStore.are_item_placed())

extends SwitchButton
class_name RacingButton

@export var disable_color: Color
@export var instructions_path: NodePath

@onready var shadow: ButtonShadow = $BtnShadow

var instructions: Label

var enabled := false

func _ready() -> void:
	instructions = get_node(instructions_path)

	to_mode = Store.GameMode.RACING
	GameStore.start_validated.connect(on_validation)
	GameStore.goal_validated.connect(on_validation)
	GameStore.checkpoint_validated.connect(func (_index, valid): on_validation(valid))
	GameStore.mode_changed.connect(on_mode_change)
	enable(false)

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed() && enabled:
		GameStore.reset_checkpoints()
		GameStore.change_mode(to_mode)

func enable(value: bool):
	enabled = value
	modulate = Color.WHITE if enabled else disable_color
	instructions.visible = value
	shadow.enabled = value

func on_validation(valid: bool):
	enable(valid && GameStore.are_item_placed())

func on_mode_change(mode: Store.GameMode):
	if mode == Store.GameMode.PAINTING:
		enable(GameStore.are_item_placed())

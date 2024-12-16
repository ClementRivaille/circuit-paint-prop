extends Sprite2D

@export var default: Texture2D
@export var brush: Texture2D
@export var grab_hover: Texture2D
@export var grabbing: Texture2D

var width: int = 0
var on_canva := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	width = default.get_width()

	GameStore.hover_grab.connect(on_hover_grab)
	GameStore.start_grab.connect(on_start_drag)
	GameStore.exit_grab.connect(on_exit_drag)
	GameStore.mode_changed.connect(on_change_mode)

func _process(_delta: float) -> void:
	var pos := get_viewport().get_mouse_position()
	set_global_position(pos)
	GameStore.set_cursor_position(pos)

func _input(event: InputEvent) -> void:
	if GameStore.current_mode == Store.GameMode.RACING: return

	if (GameStore.is_cursor_free() && event.is_action_pressed("click") && on_canva):
		GameStore.set_painting(true)
	elif (GameStore.painting && event.is_action_released("click")):
		GameStore.set_painting(false)
		set_texture_neutral()

func set_texture_neutral() -> void:
	if GameStore.current_mode != Store.GameMode.PAINTING:
		texture = default
	elif (GameStore.hovering_grab):
		texture = grab_hover
	elif on_canva:
		texture = brush
	else:
		texture = default

func enter_canva():
	on_canva = true
	if GameStore.is_cursor_free() && GameStore.current_mode == Store.GameMode.PAINTING:
		texture = brush

func exit_canva():
	on_canva = false
	if (GameStore.is_cursor_free()):
		texture = default

func on_hover_grab():
	if (!GameStore.painting && !GameStore.dragging):
		texture = grab_hover
func on_start_drag():
	texture = grabbing
func on_exit_drag():
	if (!GameStore.painting):
		set_texture_neutral()

func on_change_mode(mode: Store.GameMode):
	visible = mode != Store.GameMode.RACING

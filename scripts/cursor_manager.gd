extends Sprite2D


@export var default: Texture2D
@export var brush: Texture2D

var width: int = 0
var on_canva := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	width = default.get_width()

func _process(_delta: float) -> void:
	var pos := get_viewport().get_mouse_position()
	set_global_position(pos)
	GameStore.set_cursor_position(pos)

func _input(event: InputEvent) -> void:
	if (!GameStore.painting && event.is_action_pressed("click") && on_canva):
		GameStore.set_painting(true)
	elif (GameStore.painting && event.is_action_released("click")):
		GameStore.set_painting(false)
		if (!on_canva):
			texture = default

func enter_canva():
	on_canva = true
	texture = brush

func exit_canva():
	on_canva = false
	if (!GameStore.painting):
		texture = default

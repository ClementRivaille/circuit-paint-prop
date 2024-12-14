extends Node
class_name Store

signal painting_change(p: bool)
signal start_grab
signal hover_grab
signal exit_grab

var cursor_position: Vector2:
	get = get_cursor_position, set = set_cursor_position
func get_cursor_position():
	return cursor_position
func set_cursor_position(pos: Vector2):
	cursor_position = Vector2(pos)

var painting: bool = false:
	set = set_painting
func set_painting(value: bool):
	painting = value
	painting_change.emit(value)

var selected_color: Vector2i = Vector2i(0,0):
	set = set_selected_color
func set_selected_color(tile: Vector2i):
	selected_color = tile

var dragging := false
var hovering_grab := false

func hover_grab_item():
	hovering_grab = true
	hover_grab.emit()
func drag_item():
	dragging = true
	start_grab.emit()
func drop_item():
	dragging = false
func exit_grab_item():
	hovering_grab = false
	exit_grab.emit()

func is_cursor_free() -> bool:
	return !painting && !dragging && !hovering_grab

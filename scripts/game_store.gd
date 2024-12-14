extends Node
class_name Store

signal painting_change(p: bool)

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

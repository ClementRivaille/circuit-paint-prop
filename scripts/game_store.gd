extends Node
class_name Store

signal painting_change(p: bool)

var cursor_position: Vector2:
	get = get_cursor_position, set = set_cursor_position
var painting: bool = false:
	set = set_painting

func get_cursor_position():
	return cursor_position

func set_cursor_position(pos: Vector2):
	cursor_position = Vector2(pos)

func set_painting(value: bool):
	painting = value
	painting_change.emit(value)

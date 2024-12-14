extends Node
class_name Store

signal painting_change(p: bool)
signal start_grab
signal hover_grab
signal exit_grab
signal mode_changed(mode: GameMode)

enum TrackItemType { START, CHECKPOINT, GOAL }
enum GameMode { PAINTING, RACING, RESULTS }

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
func exit_grab_item():
	hovering_grab = false
	exit_grab.emit()

func drop_item(type: TrackItemType, position: Vector2i, index: int = -1):
	dragging = false

	if (type == TrackItemType.START):
		start_position = position
	elif (type == TrackItemType.GOAL):
		goal_position = position
	elif (index >= 0 && index < checkpoints.size()):
		checkpoints[index] = position

func is_cursor_free() -> bool:
	return !painting && !dragging && !hovering_grab

var goal_position := Vector2i(0, 0)
var start_position := Vector2i(0,0)
var checkpoints: Array[Vector2i] = []

var tilemap_position := Vector2(0,0)
var tilemap: TileMapLayer:
	set = set_tilemap
func set_tilemap(tilemap_inst: TileMapLayer):
	tilemap = tilemap_inst
	tilemap_position = tilemap.global_position

func get_position_on_map(world_pos: Vector2) -> Vector2i:
	var local_pos := world_pos - tilemap_position
	return tilemap.local_to_map(local_pos)

func get_global_position(map_pos: Vector2i) -> Vector2:
	var local_pos := tilemap.map_to_local(map_pos)
	return local_pos + tilemap_position

func generate_checkpoints(checkpoints_positions: Array[Vector2i]):
	checkpoints = checkpoints_positions.duplicate()

var current_mode: GameMode =  GameMode.PAINTING

func change_mode(mode: GameMode):
	current_mode = mode
	mode_changed.emit(mode)

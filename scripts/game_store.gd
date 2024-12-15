extends Node
class_name Store

signal painting_change(p: bool)
signal color_changed(color: Vector2i)
signal start_grab
signal hover_grab
signal exit_grab
signal item_dropped
signal mode_changed(mode: GameMode)
signal checkpoint_collected
signal goal_reached
signal start_validated(valid: bool)
signal goal_validated(valid: bool)
signal checkpoint_validated(index: int, valid: bool)
signal validation_needed
signal chrono_time_updated(time: int)
signal start_race
signal update_level_idx(idx: int)
signal level_begin(level: Level)

enum TrackItemType { START, CHECKPOINT, GOAL }
enum GameMode { PAINTING, RACING, RESULTS, TITLE }

var END_DELAY := 2.0
var CANVA_DIMENSIONS := Vector2(200,200)

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
	if (!painting):
		validation_needed.emit()

var selected_color: Vector2i = Vector2i(0,0):
	set = set_selected_color
func set_selected_color(tile: Vector2i):
	selected_color = tile
	color_changed.emit(selected_color)

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

	validation_needed.emit()
	item_dropped.emit()

func is_cursor_free() -> bool:
	return !painting && !dragging && !hovering_grab

var goal_position := Vector2i(0, 0)
var start_position := Vector2i(0,0)
var checkpoints: Array[Vector2i] = []
var start_valid := false
var goal_valid := false
var checkpoints_valid: Array[bool] = []

var tilemap_position := Vector2(0,0)
var tilemap: TileMapLayer
var level_tilemap: TileMapLayer
func set_tilemaps(tilemap_inst: TileMapLayer, level: TileMapLayer):
	tilemap = tilemap_inst
	level_tilemap = level
	tilemap_position = tilemap.global_position

func get_position_on_map(world_pos: Vector2) -> Vector2i:
	var local_pos := world_pos - tilemap_position
	return tilemap.local_to_map(local_pos)

func get_global_position(map_pos: Vector2i) -> Vector2:
	var local_pos := tilemap.map_to_local(map_pos)
	return local_pos + tilemap_position

func generate_checkpoints(checkpoints_positions: Array[Vector2i]):
	checkpoints = checkpoints_positions.duplicate()
	checkpoints_valid = []
	for c in checkpoints:
		checkpoints_valid.append(false)

func validate_start(valid: bool):
	start_valid = valid
	start_validated.emit(valid)

func validate_goal(valid: bool):
	goal_valid = valid
	goal_validated.emit(valid)

func validate_checkpoint(index: int, valid: bool):
	if index >= checkpoints_valid.size(): return
	checkpoints_valid[index] = valid
	checkpoint_validated.emit(index, valid)

func are_item_placed() -> bool:
	var items_valid := start_valid && goal_valid && checkpoints_valid.all(func (valid): return valid)
	var all_pos: Array[Vector2i] = [start_position, goal_position]
	all_pos.append_array(checkpoints)
	var all_in_canva := all_pos.all(func (pos: Vector2i): return is_within_canva(pos))

	return items_valid && all_in_canva

func is_within_canva(point: Vector2i) -> bool:
	return abs(point.x) <= CANVA_DIMENSIONS.x / 2.0 && abs(point.y) <= CANVA_DIMENSIONS.y / 2.0

func read_cell_flag(cell: Vector2i, flag: String) -> bool:
	var level_cell := level_tilemap.get_cell_atlas_coords(cell).x != -1
	var target_tilemap := level_tilemap if level_cell else tilemap
	var cell_data := target_tilemap.get_cell_tile_data(cell)
	if (cell_data == null):
		return false
	var value = cell_data.get_custom_data(flag)
	return value if value != null else false


## ---- RACE

var current_mode: GameMode =  GameMode.TITLE
var total_checkpoints := 4: set = set_total_checkpoints
func set_total_checkpoints(total: int): total_checkpoints = total
var checkpoints_collected := 0
var chrono_time := 0: set = set_chrono_time
func set_chrono_time(time: int):
	chrono_time = time
	chrono_time_updated.emit(time)

func change_mode(mode: GameMode):
	current_mode = mode
	mode_changed.emit(mode)
	if mode == GameMode.RACING:
		start_race.emit()

func collect_checkpoint():
	checkpoints_collected += 1
	checkpoint_collected.emit()

func reset_checkpoints():
	checkpoints_collected = 0

func reach_goal():
	goal_reached.emit()
	await get_tree().create_timer(END_DELAY).timeout
	change_mode(Store.GameMode.RESULTS)

func reset_chrono_time():
	chrono_time = 0
	chrono_time_updated.emit(chrono_time)

### Levels

var level_idx := -1
var total_levels := 0: set = init_total_levels
func init_total_levels(total: int): total_levels = total
var current_level: Level

func next_level():
	# TODO: something at the end of the game
	level_idx = (level_idx + 1) % total_levels
	update_level_idx.emit(level_idx)

func load_level(level: Level):
	current_level = level
	set_total_checkpoints(level.nb_checkpoints)
	level_begin.emit(current_level)

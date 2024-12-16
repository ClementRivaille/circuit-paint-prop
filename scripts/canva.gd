extends TileMapLayer
class_name PaintingCanva

signal mouse_entered
signal mouse_exited

@onready var level_canva: TileMapLayer = $LevelCanva

func _ready() -> void:
	GameStore.set_tilemaps(self, level_canva)
	GameStore.level_begin.connect(init_level)

func _process(_delta: float) -> void:
	if (GameStore.painting):
		var cursor_pos := GameStore.get_position_on_map(GameStore.cursor_position)
		paint_circle(cursor_pos.x, cursor_pos.y, GameStore.brush_size)

func paint_circle(cx: int, cy: int, r: int):
	# Midpoint circle algorithm
	var x := 0
	var y := -r
	var p := -r # -0.25?

	while x < -y:
		if p > 0:
			# coordinates outside
			y += 1
			p += 2*(x+y) + 1
		else:
			# inside
			p += 2*x + 1

		draw_octants(Vector2i(cx, cy), Vector2i(x, y))
		x += 1

func draw_octants(center: Vector2i, point: Vector2i):
	# set_cell(Vector2i(center.x + point.x, center.y + point.y), 0, selected_tile)
	draw_circle_line(center, point.x, point.y)
	draw_circle_line(center, abs(point.y), point.x)
	draw_circle_line(center, abs(point.y), -point.x)
	draw_circle_line(center, point.x, -point.y)

func draw_circle_line(center: Vector2i, width: int, y: int):
	var point := Vector2i(center.x - width, center.y + y)
	while point.x <= center.x + width:
		if GameStore.is_within_canva(point) && !is_cell_set_by_level(point):
			set_cell(point, 0, GameStore.selected_color)
		point.x += 1

func init_level(level: Level):
	clear()

	# draw level canva
	var template: TileMapLayer = level.map.instantiate()
	level_canva.tile_map_data = template.tile_map_data
	template.queue_free()

	var width := GameStore.CANVA_DIMENSIONS.x / 2
	var height := GameStore.CANVA_DIMENSIONS.y / 2
	for x in range(-width, width+1):
		for y in range(-height, height+1):
			if !is_cell_set_by_level(Vector2i(x,y)):
				set_cell(Vector2i(x,y), 0, level.fill)

func is_cell_set_by_level(coord: Vector2i)-> bool:
	return level_canva.get_cell_atlas_coords(coord).x != -1


func _on_mouse_entered() -> void:
	mouse_entered.emit()

func _on_mouse_exited() -> void:
	mouse_exited.emit()

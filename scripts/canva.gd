extends TileMapLayer
class_name PaintingCanva

@export var brush_radius: int =10

func _enter_tree() -> void:
	GameStore.set_tilemap(self)

func _process(_delta: float) -> void:
	if (GameStore.painting):
		var cursor_pos := GameStore.get_position_on_map(GameStore.cursor_position)
		paint_circle(cursor_pos.x, cursor_pos.y, brush_radius)

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
		if GameStore.is_within_canva(point):
			set_cell(point, 0, GameStore.selected_color)
		point.x += 1

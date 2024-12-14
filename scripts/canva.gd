extends TileMapLayer
class_name PaintingCanva

@export var brush_radius: int =10
@export var canva_width := 200
@export var canva_height := 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (GameStore.painting):
		var local_pos := GameStore.cursor_position - (get_viewport().get_visible_rect().size / 2)
		var cursor_pos := local_to_map(local_pos)
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
	var ypos := center.y + y
	var xpos := center.x - width
	while xpos <= center.x + width:
		if abs(xpos) <= canva_width / 2.0 && abs(ypos) <= canva_height / 2.0:
			set_cell(Vector2i(xpos, ypos), 0, GameStore.selected_color)
		xpos += 1

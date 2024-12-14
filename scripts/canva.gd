extends TileMapLayer
class_name PaintingCanva

var selected_tile := Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameStore.painting):
		var local_pos := GameStore.cursor_position - (get_viewport().get_visible_rect().size / 2)
		var cursor_pos := local_to_map(local_pos)
		set_cell(cursor_pos, 0, selected_tile)

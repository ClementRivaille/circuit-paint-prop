extends TextureRect

@export var default_color := Color.WHITE
@export var selected_color := Color.BLACK
@export var brush_size := 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_selected(GameStore.brush_size)
	GameStore.brush_changed.connect(set_selected)

func set_selected(selected_size: int):
	modulate = selected_color if selected_size == brush_size else default_color


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		GameStore.set_brush_size(brush_size)

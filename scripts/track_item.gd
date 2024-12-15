extends Area2D
class_name TrackItem

@export var type: Store.TrackItemType
@export var index: int = -1
@export var locked := false

@export var checkpoint_texture: Texture2D
@export var start_texture: Texture2D
@export var goal_texture: Texture2D

@export var min_pos := Vector2(0.0, 0.0)
@export var max_pos := Vector2(400.0, 224.0)
@export var invalid_color: Color

@onready var outline: Sprite2D = $Outline
@onready var fill: Sprite2D = $Fill
@onready var icon: Sprite2D = $Icon

var dragged := false
var mouse_inside := false
var pos_diff := Vector2(0.0, 0.0)

func _ready() -> void:
	if type == Store.TrackItemType.START:
		icon.texture = start_texture
	elif type == Store.TrackItemType.GOAL:
		icon.texture = goal_texture
	else:
		icon.texture = checkpoint_texture

	outline.visible = false
	fill.visible = false

func _process(_delta: float) -> void:
	if dragged:
		var mouse_pos := get_viewport().get_mouse_position()
		position.x = clampf(mouse_pos.x - pos_diff.x, min_pos.x, max_pos.x)
		position.y = clampf(mouse_pos.y - pos_diff.y, min_pos.y, max_pos.y)
		pos_diff = mouse_pos - global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && !locked:
		if event.is_pressed() && mouse_inside && !GameStore.dragging:
			dragged = true
			fill.visible = true
			pos_diff = get_viewport().get_mouse_position() - global_position
			GameStore.drag_item()
		elif dragged && !event.is_pressed():
			dragged = false
			fill.visible = false
			var map_pos := GameStore.get_position_on_map(global_position)
			GameStore.drop_item(type, map_pos, index)
			if mouse_inside:
				GameStore.hover_grab_item()
			else:
				GameStore.exit_grab_item()
				outline.visible = false

func _on_mouse_entered() -> void:
	mouse_inside = true
	if !dragged && !locked:
		outline.visible = true
		GameStore.hover_grab_item()

func _on_mouse_exited() -> void:
	mouse_inside = false
	if !dragged && !locked:
		outline.visible = false
		GameStore.exit_grab_item()

func set_valid(valid: bool):
	fill.visible = !valid || dragged
	fill.self_modulate = Color.WHITE if valid else invalid_color

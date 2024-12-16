extends Control
class_name ColorSelect

@export var outline_color := Color.WHITE
@export var outline_color_selected := Color.BLACK
@export var icon: Texture2D
@export var text := ""
@export var tile: Vector2i

@onready var fill: TextureRect = $Button/Fill
@onready var icon_display: TextureRect = $Icon
@onready var label: Label = $Label
@onready var outline: Control = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_display.texture = icon
	label.text = text

	GameStore.color_changed.connect(update_selection)
	GameStore.palette_changed.connect(update_palette)
	update_selection(GameStore.selected_color)

func on_click():
	GameStore.set_selected_color(tile)

func update_selection(selected: Vector2i):
	outline.self_modulate = outline_color_selected if selected == tile else outline_color

func update_palette(palette):
	fill.self_modulate = GameStore.get_palette_color(tile)

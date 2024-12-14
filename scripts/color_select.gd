extends Control
class_name ColorSelect

@export var color: Color
@export var icon: Texture2D
@export var text := ""
@export var tile: Vector2i

@onready var fill: TextureRect = $Button/Fill
@onready var icon_display: TextureRect = $Icon
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill.self_modulate = color
	icon_display.texture = icon
	label.text = text

func on_click():
	GameStore.set_selected_color(tile)

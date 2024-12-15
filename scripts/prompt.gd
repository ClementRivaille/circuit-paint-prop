extends Control
class_name Prompt

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.level_begin.connect(set_level_prompt)


func set_level_prompt(level: Level):
	label.text = level.prompt

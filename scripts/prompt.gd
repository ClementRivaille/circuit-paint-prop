extends Control
class_name Prompt

@onready var label: Label = $Label

var prompt: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.level_begin.connect(set_level_prompt)
	GameStore.mode_changed.connect(display_on_mode)


func set_level_prompt(level: Level):
	prompt = level.prompt

func display_on_mode(mode: Store.GameMode):
	if mode == Store.GameMode.PAINTING:
		label.text = "Draw: " + prompt
	else:
		label.text = prompt

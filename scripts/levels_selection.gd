extends Node2D
class_name LevelsSelection

@export var levels: Array[Level]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.init_total_levels(levels.size())
	GameStore.update_level_idx.connect(load_next_level)

	# TODO load first level on title screen?
	GameStore.next_level()

func load_next_level(idx: int):
	GameStore.load_level(levels[idx])

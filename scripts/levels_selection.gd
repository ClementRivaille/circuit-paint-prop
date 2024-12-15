extends Node2D
class_name LevelsSelection

@export var levels: Array[Level]

func _ready() -> void:
	GameStore.init_total_levels(levels.size())
	GameStore.update_level_idx.connect(load_next_level)

func load_next_level(idx: int):
	GameStore.load_level(levels[idx])

extends Node2D
class_name LevelsSelection

@export var levels: Array[Level]
@export var free_prompts: Array[String] = []
@export var nb_palettes: int = 11

var prompts_played: Array[int] = []

func _ready() -> void:
	GameStore.init_total_levels(levels.size())
	GameStore.update_level_idx.connect(load_next_level)
	GameStore.load_random_level.connect(load_random_level)

func load_next_level(idx: int):
	GameStore.load_level(levels[idx])

func generate_level() -> Level:
	var level = Level.new()

	level.nb_checkpoints = 4
	var prompt_index := randi_range(0, free_prompts.size() - 1)
	while prompts_played.has(prompt_index):
		prompt_index = randi_range(0, free_prompts.size() - 1)
	level.prompt = free_prompts[prompt_index]
	level.palette_id = randi() % nb_palettes

	if prompts_played.size() >= free_prompts.size():
		prompts_played.clear()

	return level

func load_random_level():
	var level := generate_level()
	GameStore.load_level(level)

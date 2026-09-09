@tool
extends Node
class_name SaveManager

var SAVE_LOCATION := "user://savegame.save"

var current_save: GameSave

@export_tool_button("Clear save") var clear_save_action = clear_save

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	var has_save := read_save()
	if has_save:
		GameStore.load_save(current_save)
	else:
		current_save = GameSave.new()

	GameStore.mode_changed.connect(on_change_mode)

func save() -> void:
	var save_dict := current_save.serialize()

	var save_file := FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	var json_data := JSON.stringify(save_dict)
	save_file.store_line(json_data)
	save_file.close()

func read_save() -> bool:
	if not FileAccess.file_exists(SAVE_LOCATION):
		return false

	var save_file := FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	if save_file.get_position() >= save_file.get_length():
		return false

	var json_str := save_file.get_line()
	var json := JSON.new()
	var parse_result := json.parse(json_str)
	if parse_result != OK:
		return false

	var data : Dictionary = json.data
	current_save = GameSave.load(data)
	return true

func on_change_mode(mode: GameStore.GameMode):
	if mode == GameStore.GameMode.RESULTS:
		current_save.played_levels = GameStore.played_levels
		current_save.tutorial_completed = true
		if GameStore.all_level_played():
			current_save.finished_game = true
			current_save.played_levels.clear()

		save()

func clear_save():
	if not FileAccess.file_exists(SAVE_LOCATION):
		return
	DirAccess.remove_absolute(SAVE_LOCATION)

extends Resource
class_name GameSave

var played_levels: Array[int] = []
var tutorial_completed := false
var finished_game := false

func serialize() -> Dictionary:
	return {
		"played_levels": played_levels,
		"tutorial_completed": tutorial_completed,
		"finished_game": finished_game
	}

static func load(dict: Dictionary) -> GameSave:
	var new_save = GameSave.new()
	if dict.has("played_levels") && dict["played_levels"] is Array:
		for lvl in dict["played_levels"]:
			new_save.played_levels.append(int(lvl))
	if(dict.has("tutorial_completed") && dict["tutorial_completed"] is bool):
		new_save.tutorial_completed = dict["tutorial_completed"]
	if(dict.has("finished_game") && dict["finished_game"] is bool):
		new_save.finished_game = dict["finished_game"]

	return new_save

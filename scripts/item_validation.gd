extends Node2D
class_name ItemValidation

@export var min_distance := 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.validation_needed.connect(validate_items)

func validate_items():
	var select_pos: Array[Vector2i] = []
	# start
	select_pos = GameStore.checkpoints.duplicate()
	select_pos.append(GameStore.goal_position)
	var start_dist =  is_item_separated(GameStore.start_position, select_pos)
	var start_blocked = is_item_blocked(GameStore.start_position)
	GameStore.validate_start(start_dist && !start_blocked)

	# goal
	select_pos = GameStore.checkpoints.duplicate()
	select_pos.append(GameStore.start_position)
	var goal_dist =  is_item_separated(GameStore.goal_position, select_pos)
	var goal_blocked = is_item_blocked(GameStore.goal_position)
	GameStore.validate_goal(goal_dist && !goal_blocked)

	# checkpoints
	for index in range(GameStore.checkpoints.size()):
		select_pos = GameStore.checkpoints.duplicate()
		select_pos.remove_at(index)
		select_pos.append_array([GameStore.start_position, GameStore.goal_position])
		var checkpoint_dist = is_item_separated(GameStore.checkpoints[index], select_pos)
		var checkpoint_blocked = is_item_blocked(GameStore.checkpoints[index])
		GameStore.validate_checkpoint(index, checkpoint_dist && !checkpoint_blocked)

func is_item_separated(position: Vector2i, others: Array[Vector2i])-> bool:
	return others.all(func (pos):
		return position.distance_to(pos) > min_distance
	)

func is_item_blocked(position: Vector2i):
	return GameStore.read_cell_flag(position, "wall") || GameStore.read_cell_flag(position, "death")

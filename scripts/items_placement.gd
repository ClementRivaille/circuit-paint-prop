extends Node2D
class_name ItemsPlacement

@export var cell_size := Vector2(32, 32)
@export var item_prefab: PackedScene

@onready var start_item: TrackItem = $Start
@onready var goal_item: TrackItem = $Goal
@onready var selection_target: Node2D = $SelectionTarget
@onready var checkpoints: Array[TrackItem] = []

func _ready() -> void:
	GameStore.mode_changed.connect(on_mode_change)
	GameStore.start_validated.connect(set_start_validation)
	GameStore.goal_validated.connect(set_goal_validation)
	GameStore.checkpoint_validated.connect(set_checkpoint_validation)
	GameStore.level_begin.connect(init_canva)

func init_canva(level: Level):
	await GameStore.end_transition

	# place start item
	if (level.locked_start):
		var global_start_pos := GameStore.get_global_position(level.start_position)
		start_item.position = to_local(global_start_pos)
	else:
		start_item.position = selection_target.position
	start_item.locked = level.locked_start
	GameStore.drop_item(Store.TrackItemType.START, GameStore.get_position_on_map(start_item.global_position))

	reset_checkpoints()
	var grid_pos := Vector2(0 if level.locked_start else 1,0)
	# generate checkpoins
	var checkpoints_pos: Array[Vector2i] = []
	for idx in range(0, GameStore.total_checkpoints):
		var checkpoint_item: TrackItem = item_prefab.instantiate()
		checkpoint_item.type = Store.TrackItemType.CHECKPOINT
		checkpoint_item.index = idx

		if level.checkpoints_positions.size() > idx:
			var global_pos := GameStore.get_global_position(level.checkpoints_positions[idx])
			checkpoint_item.position = to_local(global_pos)
			checkpoint_item.locked = true
		else:
			var grid_placement := selection_target.position + grid_pos * cell_size
			checkpoint_item.position = grid_placement
			if grid_pos.x == 0:
				grid_pos.x = 1
			else:
				grid_pos.x = 0
				grid_pos.y += 1

		add_child(checkpoint_item)
		checkpoints.append(checkpoint_item)
		checkpoints_pos.append(GameStore.get_position_on_map(checkpoint_item.global_position))

	GameStore.generate_checkpoints(checkpoints_pos)

	# place goal item
	if level.locked_goal:
		var global_goal_pos := GameStore.get_global_position(level.goal_position)
		goal_item.position = to_local(global_goal_pos)
	else:
		goal_item.position = selection_target.position + grid_pos * cell_size
	goal_item.locked = level.locked_goal
	GameStore.drop_item(Store.TrackItemType.GOAL, GameStore.get_position_on_map(goal_item.global_position))

func on_mode_change(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		visible = false
	elif mode == Store.GameMode.PAINTING || mode == Store.GameMode.RESULTS:
		visible = true

func set_start_validation(valid: bool):
	start_item.set_valid(valid)

func set_goal_validation(valid: bool):
	goal_item.set_valid(valid)

func set_checkpoint_validation(index: int, valid: bool):
	checkpoints[index].set_valid(valid)

func reset_checkpoints():
	for checkpoint in checkpoints:
		checkpoint.queue_free()
	checkpoints = []

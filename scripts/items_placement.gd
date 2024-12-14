extends Node2D
class_name ItemsPlacement

@export var cell_size := Vector2(32, 32)
@export var item_prefab: PackedScene

@onready var start_item: TrackItem = $Start
@onready var goal_item: TrackItem = $Goal
@onready var selection_target: Node2D = $SelectionTarget
@onready var checkpoints: Array[TrackItem] = []

func _ready() -> void:
	init_canva()
	GameStore.mode_changed.connect(on_mode_change)
	GameStore.start_validated.connect(set_start_validation)
	GameStore.goal_validated.connect(set_goal_validation)
	GameStore.checkpoint_validated.connect(set_checkpoint_validation)

func init_canva():
	# place start item
	start_item.position = selection_target.position
	GameStore.drop_item(Store.TrackItemType.START, GameStore.get_position_on_map(start_item.global_position))

	var grid_pos := Vector2(1,0)
	# generate checkpoins
	var checkpoints_pos: Array[Vector2i] = []
	for idx in range(0, GameStore.total_checkpoints):
		var checkpoint_item: TrackItem = item_prefab.instantiate()
		checkpoint_item.type = Store.TrackItemType.CHECKPOINT
		checkpoint_item.index = idx

		var grid_placement := selection_target.position + grid_pos * cell_size
		checkpoint_item.position = grid_placement

		add_child(checkpoint_item)
		checkpoints.append(checkpoint_item)
		checkpoints_pos.append(GameStore.get_position_on_map(checkpoint_item.global_position))

		if grid_pos.x == 0:
			grid_pos.x = 1
		else:
			grid_pos.x = 0
			grid_pos.y += 1

	GameStore.generate_checkpoints(checkpoints_pos)

	# place goal item
	goal_item.position = selection_target.position + grid_pos * cell_size
	GameStore.drop_item(Store.TrackItemType.GOAL, GameStore.get_position_on_map(goal_item.global_position))

func on_mode_change(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		visible = false
	elif mode == Store.GameMode.PAINTING:
		visible = true

func set_start_validation(valid: bool):
	start_item.set_valid(valid)

func set_goal_validation(valid: bool):
	goal_item.set_valid(valid)

func set_checkpoint_validation(index: int, valid: bool):
	checkpoints[index].set_valid(valid)

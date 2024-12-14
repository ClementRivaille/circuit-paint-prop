extends Node2D
class_name TrackObjects

@export var checkpoint_prefab: PackedScene
@export var end_delay := 2.0

@onready var goal: Goal = $Goal
var checkpoints: Array[Checkpoint] = []

func _ready() -> void:
	visible = false
	GameStore.mode_changed.connect(on_change_mode)
	GameStore.checkpoint_collected.connect(on_checkpoint)

	goal.reach.connect(finish_race)

func on_change_mode(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		place_items()
		visible = true
	else:
		remove_items()
		visible = false

func finish_race():
	GameStore.reach_goal()

func place_items():
	var goal_global_pos := GameStore.get_global_position(GameStore.goal_position)
	goal.enable(false)
	goal.position = to_local(goal_global_pos)

	for checkpoint_pos in GameStore.checkpoints:
		var checkpoint: Checkpoint = checkpoint_prefab.instantiate()
		var checkpoint_global_pos := GameStore.get_global_position(checkpoint_pos)
		checkpoint.position = to_local(checkpoint_global_pos)
		checkpoint.collected.connect(collect_checkpoint)
		add_child(checkpoint)
		checkpoints.append((checkpoint))

func remove_items():
	for checkpoint in checkpoints:
		checkpoint.queue_free()
	checkpoints = []

func collect_checkpoint(checkpoint: Checkpoint):
	GameStore.collect_checkpoint()
	var index := checkpoints.find(checkpoint)
	if index >= 0:
		checkpoints.remove_at(index)
	checkpoint.queue_free()

func on_checkpoint():
	if GameStore.checkpoints_collected >= GameStore.total_checkpoints:
		goal.enable(true)

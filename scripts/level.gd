extends Resource
class_name Level

@export var prompt: String
@export var nb_checkpoints := 3

@export var locked_start := false
@export var start_position := Vector2i(0,0)

@export var locked_goal := false
@export var goal_position := Vector2i(0,0)

@export var checkpoints_positions: Array[Vector2i]

@export var fill := Vector2i(1,0)
@export var map: PackedScene
@export var palette_id: int

extends Control
class_name RacingUI

@export var checkpoint_complete_color: Color
@export var victory_label := "FINISHED!"

@onready var checkpoint_counts = $Checkpoints/Label
@onready var checkpoints_area = $Checkpoints
@onready var hero_label = $Hero

var locked := false

func _ready() -> void:
	GameStore.mode_changed.connect(on_mode_change)
	GameStore.checkpoint_collected.connect(on_checkpoint_collect)
	GameStore.goal_reached.connect(display_victory)
	visible = false
	checkpoints_area.modulate =	Color.WHITE
	hero_label.visible = false

func _input(event: InputEvent) -> void:
	if !locked && GameStore.current_mode == Store.GameMode.RACING && event.is_action_pressed("exit"):
		GameStore.change_mode(Store.GameMode.PAINTING)

func on_mode_change(mode: Store.GameMode):
	visible = mode == Store.GameMode.RACING
	if visible:
		checkpoint_counts.text = str(GameStore.checkpoints_collected) + "/" + str(GameStore.total_checkpoints)
		checkpoints_area.modulate = Color.WHITE
		hero_label.visible = false
		locked = false

func on_checkpoint_collect():
	checkpoint_counts.text = str(GameStore.checkpoints_collected) + "/" + str(GameStore.total_checkpoints)
	if (GameStore.checkpoints_collected == GameStore.total_checkpoints):
		checkpoints_area.modulate = checkpoint_complete_color

func display_victory():
	hero_label.visible = true
	hero_label.text = victory_label
	locked = true

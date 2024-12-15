extends Node2D
class_name RacingSounds

@onready var checkpoint: AudioStreamPlayer = $Checkpoint
@onready var finish: AudioStreamPlayer = $Finish

func _ready() -> void:
	GameStore.checkpoint_collected.connect(play_checkpoint)
	GameStore.goal_reached.connect(play_finish)

func play_checkpoint():
	checkpoint.play()

func play_finish():
	finish.play()

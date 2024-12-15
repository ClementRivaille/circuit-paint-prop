extends Node2D
class_name SwitchSceneSFX

@onready var next: AudioStreamPlayer = $Next
@onready var back: AudioStreamPlayer = $Back

var level_idx := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_idx = GameStore.level_idx
	GameStore.mode_changed.connect(on_scene_change)

func on_scene_change(mode: Store.GameMode):
	if (mode == Store.GameMode.RACING):
		next.play()
	elif (mode == Store.GameMode.PAINTING):
		if level_idx != GameStore.level_idx:
			next.play()
			level_idx = GameStore.level_idx
		else:
			back.play()

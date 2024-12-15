extends AudioStreamPlayer

@onready var pick_color: AudioStreamPlayer = $PickColor
@onready var grab: AudioStreamPlayer = $Grab
@onready var drop: AudioStreamPlayer = $Drop

func _ready() -> void:
	GameStore.painting_change.connect(play_brush_sound)
	GameStore.color_changed.connect(on_color_change)
	GameStore.start_grab.connect(on_grab)
	GameStore.item_dropped.connect(on_drop)

func play_brush_sound(active: bool):
	if active:
		play()
	else:
		stop()

func on_color_change(_color):
	pick_color.play()
func on_grab():
	grab.play()
func on_drop():
	drop.play()

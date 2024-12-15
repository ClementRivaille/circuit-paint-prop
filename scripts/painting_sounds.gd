extends AudioStreamPlayer

func _ready() -> void:
	GameStore.painting_change.connect(play_brush_sound)

func play_brush_sound(active: bool):
	if active:
		play()
	else:
		stop()

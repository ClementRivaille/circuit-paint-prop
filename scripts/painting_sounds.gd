extends AudioStreamPlayer

func _ready() -> void:
	GameStore.painting_change.connect(play_brush_sound)

func play_brush_sound(playing: bool):
	if playing:
		play()
	else:
		stop()

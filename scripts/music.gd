extends AudioStreamPlayer

var playback: AudioStreamPlaybackInteractive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	playback = get_stream_playback()
	GameStore.mode_changed.connect(set_track)

func set_track(mode: Store.GameMode):
	if mode == Store.GameMode.RACING:
		playback.switch_to_clip_by_name("race")
	elif mode == Store.GameMode.PAINTING:
		playback.switch_to_clip_by_name("paint")

extends AudioStreamPlayer

var playback: AudioStreamPlaybackInteractive

var CLIP_MAPPING: Dictionary = {
	Store.GameMode.RACING: "race",
	Store.GameMode.PAINTING: "paint",
	Store.GameMode.TITLE: "title",
	Store.GameMode.RESULTS: "results"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	playback = get_stream_playback()
	GameStore.mode_changed.connect(set_track)

func set_track(mode: Store.GameMode):
	var clip_name: String = CLIP_MAPPING[mode]
	playback.switch_to_clip_by_name(clip_name)

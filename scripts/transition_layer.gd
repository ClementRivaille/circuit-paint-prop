extends ColorRect

@export var transition_duration := 0.3
@export var in_out_delay := 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.mode_transision.connect(on_mode_transition)
	init_anchors()

func init_anchors(vertical := false):
	set_anchor(SIDE_TOP, 1.0 if vertical else 0.0, true)
	set_anchor(SIDE_BOTTOM, 1.0, true)
	set_anchor(SIDE_LEFT, 0.0, true)
	set_anchor(SIDE_RIGHT, 1.0 if vertical else 0.0, true)

func animate_transition(vertical := false):
	init_anchors(vertical)

	var from: float = 1.0 if vertical else 0.0
	var to: float = 0.0 if vertical else 1.0

	var moved_side: Side = SIDE_TOP if vertical else SIDE_RIGHT
	var tween = create_tween()
	tween.tween_method(func (value: float):
		set_anchor(moved_side, value, true),
		from, to, transition_duration
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(transition_duration).timeout

	await get_tree().create_timer(in_out_delay).timeout

	moved_side = SIDE_BOTTOM if vertical else SIDE_LEFT
	tween = create_tween()
	tween.tween_method(func (value: float):
		set_anchor(moved_side, value, true),
		from, to, transition_duration
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func on_mode_transition(_from: Store.GameMode, to: Store.GameMode):
	var vertical := to == Store.GameMode.RACING || to == Store.GameMode.RESULTS
	animate_transition(vertical)

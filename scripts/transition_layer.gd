extends ColorRect

@export var transition_duration := 0.3
@export var in_out_delay := 0.2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.mode_transision.connect(horizontal_trans)
	init_anchors()

func init_anchors():
	set_anchor(SIDE_TOP, 0.0, true)
	set_anchor(SIDE_BOTTOM, 1.0, true)
	set_anchor(SIDE_LEFT, 0.0, true)
	set_anchor(SIDE_RIGHT, 0.0, true)

func horizontal_trans(_from, _to):
	init_anchors()

	var tween = create_tween()
	tween.tween_method(func (value: float):
		set_anchor(SIDE_RIGHT, value, true),
		0.0, 1.0, transition_duration
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(transition_duration).timeout

	await get_tree().create_timer(in_out_delay).timeout

	tween = create_tween()
	tween.tween_method(func (value: float):
		set_anchor(SIDE_LEFT, value, true),
		0.0, 1.0, transition_duration
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

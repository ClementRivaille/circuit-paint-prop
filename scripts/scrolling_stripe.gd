extends TextureRect
class_name ScrollingStripe

@export var scroll_px := 4
@export var loop_duration := 0.5


var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = create_tween().set_loops()
	tween.tween_method(func (pos_x: float):
		position.x = pos_x,
		position.x, position.x + scroll_px, loop_duration
		).set_trans(Tween.TRANS_LINEAR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

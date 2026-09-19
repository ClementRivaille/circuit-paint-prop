extends Control
class_name ButtonShadow

@export var x_offset: int = 0
@export var y_offset: int = 2

var _parent: Control
var _init_position: Vector2

var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent_node := get_parent()

	if parent_node is not Control:
		return

	_parent = parent_node
	_init_position = _parent.position
	_parent.mouse_entered.connect(on_hover)
	_parent.mouse_exited.connect(on_exit)

	set_offset(SIDE_BOTTOM, y_offset)
	#set_offset(SIDE_RIGHT, x_offset)
	visible = false

func on_hover() -> void:
	if !enabled: return

	_parent.set_position(
		Vector2(_init_position.x - roundi(float(x_offset) / 2.0),
		_init_position.y - roundi(float(y_offset) / 2.0)))
	visible = true

func on_exit() -> void:
	_parent.set_position(_init_position)
	visible = false

extends Control
class_name Debug

@onready var console = $Console

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print_item_coordinates()

func print_item_coordinates():
	console.text = "start: " + str(GameStore.start_position) \
		+ "\ncheckpoint0" + str(GameStore.checkpoints[0]) \
		+ "\ngoal: " + str(GameStore.goal_position)

func print_cursor_state():
	console.text = "dragging: " + str(GameStore.dragging) \
			+ "\nhovering: " + str(GameStore.hovering_grab) \
			+ "\npainting: " + str(GameStore.painting)

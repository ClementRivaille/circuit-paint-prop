extends Control
class_name Debug

@onready var console = $Console

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	console.text = "dragging: " + str(GameStore.dragging) \
			+ "\nhovering: " + str(GameStore.hovering_grab) \
			+ "\npainting: " + str(GameStore.painting)

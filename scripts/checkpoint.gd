extends Area2D
class_name Checkpoint

signal collected(checkpoint: Checkpoint)

func _ready() -> void:
	body_entered.connect(on_entered)

func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	rotation = camera.global_rotation

func on_entered(body: Node2D):
	if body is Kart:
		collected.emit(self)

extends Area2D
class_name Goal

signal reach

@export var success_color := Color.BLUE

var enabled := false
var reached := false

func _ready() -> void:
	body_entered.connect(on_entered)
	enable(false)

func enable(value: bool):
	enabled = value
	modulate.a = 1.0 if enabled else 0.4
	reached = false

func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	rotation = camera.global_rotation

func on_entered(_body: Node2D):
	if enabled && !reached:
		reach.emit()
		reached = true
		modulate = success_color

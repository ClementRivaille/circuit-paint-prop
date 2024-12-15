extends NinePatchRect
class_name ChronoDisplay

@onready var label: Label = $Label

@export var finish_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStore.mode_changed.connect(reset_color)
	GameStore.goal_reached.connect(show_final_time)

func _physics_process(_delta: float) -> void:
	if (GameStore.current_mode != Store.GameMode.RACING): return

	var time := GameStore.chrono_time
	var minutes := floori(time / 60_000.0)
	var sec := floori((time % 60_000) / 1_000.0)
	var ms := (time % 60_000) % 1_000

	label.text = format_number(minutes) + ":" + format_number(sec) + "." + format_number(ms, 3)

func format_number(number: int, length: int = 2) -> String:
	var res := ""
	for i in range(1, length):
		if number < pow(10, i):
			res += "0"
	res += str(number)
	return res

func show_final_time():
	label.modulate = finish_color

func reset_color(_mode):
	label.modulate = Color.WHITE

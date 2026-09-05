extends NinePatchRect
class_name ScreenshotButton

@export var title_height := 10
@export var img_scale := 4

func on_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed():
		print("clicked")
		var top_left := Vector2(
			GameStore.tilemap_position.x - GameStore.CANVA_DIMENSIONS.x / 2,
			GameStore.tilemap_position.y - GameStore.CANVA_DIMENSIONS.y / 2,)
		var region := Vector2(GameStore.CANVA_DIMENSIONS.x, GameStore.CANVA_DIMENSIONS.y + title_height)

		var screen_region := Rect2i(top_left, region)
		var screenshot := get_viewport().get_texture().get_image().get_region(screen_region)

		screenshot.resize(region.x * img_scale, region.y * img_scale, Image.INTERPOLATE_NEAREST)
		screenshot.save_png("res://dist/screenshot.png")

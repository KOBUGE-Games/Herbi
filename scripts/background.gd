extends CanvasLayer

onready var root = get_node("/root/")
onready var sprite = get_node("bg")

func update_state():
	for child in root.get_children():
		if child.get_name() == "intro":
			sprite.set_modulate(Color(0, 0, 0))
			sprite.set_scale(Vector2(320, 240))
			sprite.set_texture(preload("res://graphics/hud/square.png"))
			break
		elif child.get_name() == "menu" or child.get_name() == "world":
			sprite.set_modulate(Color(1, 1, 1))
			sprite.set_scale(Vector2(1, 1))
			sprite.set_texture(preload("res://graphics/backgrounds/fallback.jpg"))
			break

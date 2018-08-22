extends Sprite

signal pressed

export var color = Color(1,1,1)
export var name = "test"

func _ready():
	update_state()

func update_state():
	get_node("Label").set("custom_colors/font_color", color)
	get_node("Label").set_text(name)
#	if get_scale().x <= 4:
#		get_node("Label").set("custom_colors/font_color_shadow", Color(0, 0, 0, 0))
	if get_scale().x < 2:
		get_node("Label").set_scale(Vector2(0.3, 0.3))
		get_node("Label").set_size(Vector2(107, 27))

# Both funcs are virtual to simulate Button's way of working
func set_pressed(boolean):
	pass
func is_pressed():
	return true
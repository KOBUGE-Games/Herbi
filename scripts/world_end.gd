extends Position2D

onready var camera = get_node("/root/world").player.get_node("Camera2D")

func _ready():
	global.margin_right = get_pos().x - 8
	camera.set_limit(MARGIN_RIGHT, get_pos().x)
	camera.set_limit(MARGIN_BOTTOM, get_pos().y)
	get_node("/root/world").window_size = get_pos()
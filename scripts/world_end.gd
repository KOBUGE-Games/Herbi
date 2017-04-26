extends Position2D

onready var camera = get_node("/root/world/player/Camera2D")

func _ready():
	camera.set_limit(MARGIN_RIGHT, get_pos().x)
	camera.set_limit(MARGIN_BOTTOM, get_pos().y)
	get_node("/root/world").window_size = get_pos()
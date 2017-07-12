extends Position2D

func _ready():
	get_node("/root/world").player.set_pos(get_pos())
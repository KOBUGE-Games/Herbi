extends Node2D

var camera
var world_end
var level = preload("res://levels/level.tscn")

func _ready():
	add_child(level.instance())
	camera = get_node("player/Camera2D")
	world_end = get_node("world_end").get_pos()-Vector2(16,4)
	print(world_end.y)
	camera.set_limit(MARGIN_RIGHT, world_end.x)
	camera.set_limit(MARGIN_BOTTOM, world_end.y)
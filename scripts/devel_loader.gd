extends Area2D

export var level = 0
export var name = ''

onready var world = get_node("/root/world")

func _ready():
	get_node("AnimatedSprite").set_frame(randi()%2)
	get_node("AnimatedSprite").set_flip_h(randi()%2)

func load_devel(body):
	if body.get_name() == "player":
		if world.can_move:
			global.level = level
			global.level_name = name
			world.stop(false, name, true)
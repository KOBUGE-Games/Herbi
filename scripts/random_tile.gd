extends Node2D

export var frames = 1
export var random_amount = 0
export var random_tiles = 0
var random = 0

func _ready():
	random = randi() % frames
	
	if random_amount != 0:
		var add = (randi() % random_amount)
		if add > (random_amount-2):
			random += (randi()% random_tiles) + 1
	
	get_node("AnimatedSprite").set_frame(random)
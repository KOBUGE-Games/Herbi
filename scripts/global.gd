extends Node

var level = 1
var score = 0
var lives = 3

#WORKAROUND
var level_size = [[640,480],[640,480],[1344,768]]
var player_pos = [Vector2(32,416),Vector2(288,160),Vector2(32,128)]
var total_levels = level_size.size()

func _ready():
	pass
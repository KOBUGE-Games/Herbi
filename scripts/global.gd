extends Node

var debug = true
var level = 1
var score = 0
var lives = 3
var music = true
var sounds = true

#WORKAROUND
var player_pos = [Vector2(32,416),Vector2(288,160),Vector2(32,128),Vector2(1120,64)]
var total_levels = player_pos.size()

func _ready():
	pass
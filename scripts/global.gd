extends Node

var debug = true
var level = 1
var score = 0
var lives = 3
var apples = 3
var music = true
var sounds = true
var total_levels = 9

func _ready():
	randomize()

extends Node

var debug = false
var level = 1
var score = 0
var lives = 3
var apples = 3
var music = true
var sounds = true
var total_levels = 10

func _ready():
	randomize()

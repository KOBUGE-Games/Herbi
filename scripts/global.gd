extends Node

const debug = false
const version = 0.9
const total_levels = 9
var level = 1
var score = 0
var lives = 3
var apples = 3
var music = true
var sound = true

var final_score = 0
var apples_picked = 0
var life_lost = 0
var deaths = 0
var enemies_killed = 0

var finished = false

func _ready():
	randomize()
	OS.set_window_size(Vector2(640,480))
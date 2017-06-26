extends Node

const version = 0.9
const total_levels = 9
var debug = false
var level = 1
var score = 0
var lives = 3
var apples = 3

var final_score = 0
var apples_picked = 0
var life_lost = 0
var deaths = 0
var enemies_killed = 0

var finished = false

func _ready():
	randomize()
	OS.set_window_size(Vector2(640,480))
	if save_manager.config.fullscreen:
		OS.set_window_fullscreen(true)
	if save_manager.progression.first_contact:
		debug = true

func play_sound(sample):
	if save_manager.config.sound:
		sound.play(sample)
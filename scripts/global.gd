extends Node

const total_levels = 9 # Number of levels before triggering "finished"

var version = "version 0.9"
var debug = false # Enabling debug mode in-game

var score = 0 # fruits score
var lives = 3
var apples = 3 # projectiles

var final_score = 0
var apples_picked = 0
var life_lost = 0
var deaths = 0
var enemies_killed = 0

var level_name = "level_" # level name prefix to level for level scene loading
var level = 1 # level number suffix to level name for level scene loading

var finished = false # triggered on finishing the first 9 levels
var can_quit = false # set to false while transitions are active, to avoid bugs

var margin_right = 0

func _ready():
	randomize()
	OS.set_window_size(Vector2(640,480))
	if save_manager.config.fullscreen:
		OS.set_window_fullscreen(true)
	if save_manager.progression.first_contact:
		debug = true

func queue_music(sample, next_sample):
	if save_manager.config.music and not music.get_node(sample).is_playing():
		stop_music()
		music.get_node(sample).play()
		music.get_node(sample).connect("finished", self, "play_music", [next_sample])

func play_sound(sample):
	if save_manager.config.sound:
		sound.play(sample)

func play_music(sample):
	if save_manager.config.music and not music.get_node(sample).is_playing():
		stop_music()
		music.get_node(sample).set_loop(true)
		music.get_node(sample).play()

func stop_music():
	for player in music.get_children():
		if player.is_playing():
			player.set_loop(false)
			if not player.is_in_group("ambiences") or margin_right != 0:
				player.stop()

func new_timer(time):
	var timer = Timer.new()
	timer.set_name("Timer")
	timer.set_wait_time(time)
	timer.set_one_shot(1)
	return timer

func quit():
	save_manager.save_game()
	get_tree().quit()
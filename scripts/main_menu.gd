extends Node2D

var can_quit = false

onready var leave = get_node("Buttons/leave")
onready var music_button = get_node("Buttons/music")
onready var sound_button = get_node("Buttons/sound")
onready var game_won = get_node("game_won")

onready var transition = get_node("transition")

func _ready():
	if music.is_playing():
		music.stop()
	reset_global()
	global_check()
	
	get_node("Labels/version").set_text(str("version ", str(global.version)))
	transition.start(1)
	transition.connect("finished_anim", get_node("Buttons/play"), "set_disabled", [false], 4)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
	
	if can_quit:
		if event.is_action_pressed("ui_cancel"):
			if global.finished:
				hide_game_won()
			else:
				quit()
		elif event.is_action_pressed("jump") or event.is_action_pressed("restart"):
			if global.finished:
				hide_game_won()
			else:
				play()
		
		if event.type == InputEvent.KEY:
			if event.scancode == KEY_F3:
				set_music()
				music_button.set_pressed(!music_button.is_pressed())
			elif event.scancode == KEY_F4:
				set_sound()
				sound_button.set_pressed(!sound_button.is_pressed())
			if global.debug:
				if event.scancode == KEY_T:
					global.level = 0
					get_tree().change_scene("res://scenes/main.tscn")
				elif event.scancode == KEY_F9:
					get_tree().quit()

func _on_AnimationPlayer_finished():
	if get_node("Anims/Enter").get_current_animation() == "enter":
		get_tree().change_scene("res://scenes/main.tscn")

func set_music():
	global.is_music = !global.is_music

func set_sound():
	global.is_sound = !global.is_sound

func button_disable():
	for button in get_node("Buttons").get_children():
		button.set_disabled(true)

func play():
	button_disable()
	transition.start(1, true)
	transition.connect("finished_anim", get_tree(), "change_scene", ["res://scenes/main.tscn"], 4)

func quit():
	button_disable()
	transition.start(1, true)
	transition.connect("finished_anim", get_tree(), "quit")

func show_credits():
	get_node("Anims/Credits").play("show")

func hide_credits():
	get_node("Anims/Credits").play("hide")


func global_check():
	if global.finished:
		show_game_won()
	else:
		normal_state()
	if global.is_music:
		music_button.set_pressed(true)
	if global.is_sound:
		sound_button.set_pressed(true)
	if global.debug:
		get_node("Labels/debug_info").show()

func normal_state():
	game_won.hide()
	leave.set_disabled(true)
	leave.hide()

func show_game_won():
	get_node("Title").hide()
	get_node("Labels").hide()
	for node in get_node("Buttons").get_children():
		if node.get_name() != "leave":
			node.hide()
			node.set_disabled(true)
	game_won.show()
	if global.sound:
		game_won.get_node("SamplePlayer").play("win")

func hide_game_won():
	if global.finished:
		game_won.hide()
		get_node("Title").show()
		get_node("Labels").show()
		for node in get_node("Buttons").get_children():
			if node.get_name() != "leave":
				node.set_disabled(false)
				node.show()
			else:
				node.hide()
				node.set_disabled(true)
		global.finished = false

func reset_global():
	global.level = 1
	global.score = 0
	global.lives = 3
	global.apples = 3
	global.final_score = 0
	global.apples_picked = 0
	global.life_lost = 0
	global.deaths = 0
	global.enemies_killed = 0
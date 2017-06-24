extends Node2D

var can_quit = false
var credits_shown = false

onready var leave = get_node("Buttons/leave")
onready var music_button = get_node("Buttons/music")
onready var sound_button = get_node("Buttons/sound")
onready var game_won = get_node("game_won")

onready var transition = get_node("transition")

func _ready():
	for button in get_node("Buttons").get_children():
		button.connect("pressed", global, "play_sound", ["click"])
	if music.is_playing():
		music.stop()
	reset_global()
	global_check()
	
	get_node("Labels/version").set_text(str("version ", str(global.version)))
	transition.start(1)
	transition.connect("finished_anim", get_node("Buttons/play"), "set_disabled", [false], 4)
	set_process_input(true)

func _input(event):
	if can_quit:
		if event.is_action_pressed("ui_cancel"):
			if global.finished:
				hide_game_won()
			else:
				quit()
		elif event.is_action_pressed("jump"):
			if global.finished:
				hide_tab()
			else:
				play()
		
		if event.type == InputEvent.KEY:
			if global.debug:
				if event.scancode == KEY_T:
					global.level = 0
					get_tree().change_scene("res://scenes/misc/keys_info.tscn")
				elif event.scancode == KEY_F9:
					get_tree().quit()

func _on_AnimationPlayer_finished():
	if get_node("Anims/Enter").get_current_animation() == "enter":
		get_tree().change_scene("res://scenes/misc/keys_info.tscn")

func set_music():
	global.is_music = !global.is_music

func set_sound():
	global.is_sound = !global.is_sound

func set_fullscreen():
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
		get_node("Buttons/fullscreen").set_pressed(false)
	else:
		OS.set_window_fullscreen(true)
		get_node("Buttons/fullscreen").set_pressed(true)

func button_disable():
	for button in get_node("Buttons").get_children():
		button.set_disabled(true)

func play():
	button_disable()
	transition.start(1, true)
	transition.connect("finished_anim", get_tree(), "change_scene", ["res://scenes/misc/keys_info.tscn"], 4)

func quit():
	button_disable()
	transition.start(1, true)
	transition.connect("finished_anim", get_tree(), "quit")

func show_credits():
	credits_shown = true
	get_node("Anims/Tabs").play("show_credits")

func show_options():
	get_node("Anims/Tabs").play("show_options")

func hide_tab():
	if global.finished:
		game_won.hide()
		get_node("Title").show()
		get_node("Labels").show()
		for node in get_node("Buttons").get_children():
			if node.get_name() == "leave" or node extends CheckBox:
				node.set_disabled(true)
				node.hide()
			else:
				node.set_disabled(false)
				node.show()
		global.finished = false
	else:
		if credits_shown:
			get_node("Anims/Tabs").play("hide_credits")
		else:
			get_node("Anims/Tabs").play("hide_options")

func global_check():
	if global.finished:
		show_game_won()
	else:
		normal_state()
	if global.is_music:
		music_button.set_pressed(true)
	if global.is_sound:
		sound_button.set_pressed(true)
	get_node("Buttons/fullscreen").set_pressed(OS.is_window_fullscreen())
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
	if global.is_music:
		global.play_sound("win")

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
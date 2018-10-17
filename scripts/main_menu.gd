extends Node2D

signal buttons_updated

var credits_shown = false

onready var leave = get_node("Buttons/leave")
onready var music_button = get_node("Buttons/music")
onready var sound_button = get_node("Buttons/sound")
onready var game_won = get_node("game_won")

onready var transition = get_node("transition/Node2D")
onready var button_select = get_node("button_select/Node2D")

func _ready():
	for button in get_node("Buttons").get_children():
		button.connect("pressed", global, "play_sound", ["click"])
		button.connect("pressed", save_manager, "save_game")
	
	music_button.connect("pressed", self, "set_music")
	sound_button.connect("pressed", self, "set_sound")
	get_node("Buttons/fullscreen").connect("pressed", self, "set_fullscreen")
	get_node("Buttons/play").connect("pressed", self, "play")
	get_node("Buttons/options").connect("pressed", self, "show_options")
	get_node("Buttons/credits").connect("pressed", self, "show_credits")
	get_node("Buttons/exit").connect("pressed", self, "quit")
	get_node("Buttons/devel_4").connect("pressed", self, "devel_4")
	leave.connect("pressed", self, "hide_tab")
	
	if save_manager.progression.devel_4_message:
		get_node("Buttons/devel_4").show()
	
	reset_global()
	global_check()
	
	if save_manager.progression.debug:
		global.version = "DEBUG MODE"
		get_node("Labels/version").set("custom_colors/font_color", Color(1, 0, 0, 0.875))
	get_node("Labels/version").set_text(global.version)
	
	transition.queue_transition(HORIZONTAL)
	set_process_input(true)


func _input(event):
	if event.is_action_pressed("ui_cancel") and global.can_quit:
		if get_node("Buttons/leave").is_visible():
			hide_tab()
		else:
			quit()


func _on_AnimationPlayer_finished():
	if get_node("Anims/Enter").get_current_animation() == "enter":
		get_tree().change_scene("res://scenes/misc/keys_info.tscn")

func set_music():
	save_manager.config.music = !save_manager.config.music

func set_sound():
	save_manager.config.sound = !save_manager.config.sound

func set_fullscreen():
	var f = !OS.is_window_fullscreen()
	OS.set_window_fullscreen(f)
	get_node("Buttons/fullscreen").set_pressed(f)
	save_manager.config.fullscreen = f

func play():
	transition.start(HORIZONTAL, true, 0, [get_tree(), "change_scene", ["res://scenes/misc/keys_info.tscn"]])

func devel_4():
	global.level_name = "devel_"
	global.level = 4
	transition.start(HORIZONTAL, true, 0, [get_tree(), "change_scene", ["res://scenes/misc/keys_info.tscn"]])

func quit():
	transition.start(HORIZONTAL, true, 0, [global, "quit", []])

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
			if node.get_name() == "leave" or node.get_name() in ["music", "sound", "fullscreen"]:
				node.hide()
			else:
				node.show()
		button_select.set_active(null, true)
		global.finished = false
	else:
		if credits_shown:
			get_node("Anims/Tabs").play("hide_credits")
			credits_shown = false
		else:
			get_node("Anims/Tabs").play("hide_options")

func global_check():
	global.stop_music()
	if global.finished:
		show_game_won()
	else:
		normal_state()
	if save_manager.config.music:
		music_button.set_pressed(true)
	if save_manager.config.sound:
		sound_button.set_pressed(true)
	get_node("Buttons/fullscreen").set_pressed(save_manager.config.fullscreen)
	if save_manager.progression.debug:
		get_node("Labels/debug_keys").show()
		get_node("Labels/debug_info").show()

	button_select.buttons_dir = get_node("Buttons")
	button_select.set_active(null, true)

	get_node("Anims/Tabs").connect("animation_started", button_select, "set_active", [false])
	get_node("Anims/Tabs").connect("finished", button_select, "set_active", [null, true])

func normal_state():
	game_won.hide()
	leave.hide()

func show_game_won():
	save_manager.progression.first_finish = true
	get_node("Title").hide()
	get_node("Labels").hide()
	for node in get_node("Buttons").get_children():
		if not node.get_name() in ["leave", "devel_4"]:
			node.hide()
		else:
			node.show()
	game_won.show()
	if save_manager.config.sound:
		global.play_sound("win")

func reset_global():
	events_texts.in_game = false
	global.level = 1
	global.level_name = "level_"
	global.score = 0
	global.lives = 3
	global.apples = 3
	global.final_score = 0
	global.apples_picked = 0
	global.life_lost = 0
	global.deaths = 0
	global.enemies_killed = 0
	global.margin_right = 0
	background.update_state()
	get_node("Buttons/play").color = Color(255, 255, 255)
	button_anim1()

func button_anim1():
	if save_manager.progression.first_finish and not save_manager.progression.debug:
		var timer = global.new_timer(0.1)
		add_child(timer)
		timer.connect("timeout", get_node("Timer"), "queue_free")
		timer.connect("timeout", self, "button_anim1")
		if get_node("Buttons/play").color == Color(255, 255, 255):
			get_node("Buttons/play").color = Color(255, 0, 0)
		else:
			get_node("Buttons/play").color = Color(255, 255, 255)
		get_node("Buttons/play").update_state()
		timer.start()
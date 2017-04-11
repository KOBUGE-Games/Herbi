extends Node2D

onready var falling1 = get_node("Anims/Falling1")
onready var falling2 = get_node("Anims/Falling2")
onready var falling3 = get_node("Anims/Falling3")

onready var leave = get_node("Buttons/leave")
onready var music = get_node("Buttons/music")
onready var sound = get_node("Buttons/sound")
onready var game_won = get_node("game_won")

func _ready():
	reset_global()
	global_check()
	
	Falling1_start()
	Falling2_start()
	Falling3_start()
	
	get_node("Labels/version").set_text(str("version ", str(global.version)))
	set_process_input(true)

func _input(event):
	if not event.is_echo() && event.is_pressed():
		if event.is_action("jump") or event.is_action("restart"):
			play()
		elif event.type == InputEvent.KEY && event.scancode == KEY_F3:
			set_music()
			music.set_pressed(!music.is_pressed())
		elif event.type == InputEvent.KEY && event.scancode == KEY_F4:
			set_sound()
			sound.set_pressed(!sound.is_pressed())
		elif event.type == InputEvent.KEY && event.scancode == KEY_F9 or event.is_action("ui_cancel"):
			if global.finished:
				hide_game_won()
			else:
				quit()
		elif event.type == InputEvent.KEY && event.scancode == KEY_T && global.debug:
			global.level = 0
			get_tree().change_scene("res://scenes/main.tscn")

func _on_AnimationPlayer_finished():
	if get_node("Anims/Enter").get_current_animation() == "enter":
		get_tree().change_scene("res://scenes/main.tscn")

func set_music():
	global.music = !global.music

func set_sound():
	global.sound = !global.sound

func play():
	get_node("Anims/Enter").play("enter")
	get_node("Buttons/play").set_disabled(true)

func show_credits():
	get_node("Anims/Credits").play("show")

func hide_credits():
	get_node("Anims/Credits").play("hide")


func global_check():
	if global.finished:
		show_game_won()
	else:
		normal_state()
	if global.music:
		music.set_pressed(true)
	if global.sound:
		sound.set_pressed(true)
	if global.debug:
		get_node("Labels/debug_info").show()

func normal_state():
	game_won.hide()
	leave.set_disabled(true)
	leave.hide()

func show_game_won():
	get_node("Logos/logo").hide()
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
		get_node("Logos/logo").show()
		get_node("Labels").show()
		for node in get_node("Buttons").get_children():
			if node.get_name() != "leave":
				node.set_disabled(false)
				node.show()
			else:
				node.hide()
				node.set_disabled(true)
		global.finished = false


func quit():
	get_tree().quit()

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

func Falling1_start():
	falling1.get_animation("falling").track_set_key_value(0, 0, Vector2(rand_range(-120, 200), rand_range(-200, -100)))
	falling1.get_animation("falling").track_set_key_value(0, 1, Vector2(rand_range(100, 420), rand_range(300, 400)))
	falling1.get_animation("falling").track_set_key_value(1, 0, rand_range(0, 360))
	falling1.get_animation("falling").track_set_key_value(1, 1, rand_range(0, 720))
	falling1.play("falling")

func Falling2_start():
	falling2.get_animation("falling").track_set_key_value(0, 0, Vector2(rand_range(-100, 220), rand_range(-200, -100)))
	falling2.get_animation("falling").track_set_key_value(0, 1, Vector2(rand_range(0, 320), rand_range(300, 400)))
	falling2.get_animation("falling").track_set_key_value(1, 0, rand_range(0, -360))
	falling2.get_animation("falling").track_set_key_value(1, 1, rand_range(0, -720))
	falling2.play("falling")

func Falling3_start():
	falling3.get_animation("falling").track_set_key_value(0, 0, Vector2(rand_range(0, 320), rand_range(-200, -100)))
	falling3.get_animation("falling").track_set_key_value(0, 1, Vector2(rand_range(0, 320), rand_range(300, 400)))
	falling3.get_animation("falling").track_set_key_value(1, 0, rand_range(180, -180))
	falling3.get_animation("falling").track_set_key_value(1, 1, rand_range(360, -360))
	falling3.play("falling")
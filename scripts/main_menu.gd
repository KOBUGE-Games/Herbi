extends Node2D

onready var falling1 = get_node("Falling1")
onready var falling2 = get_node("Falling2")
onready var falling3 = get_node("Falling3")

func _ready():
	Falling1_start()
	Falling2_start()
	Falling3_start()
	global.level = 1
	global.score = 0
	global.lives = 3
	global.apples = 3
	if global.debug:
		get_node("debug_info").show()
	set_process_input(true)

func _input(event):
	if not event.is_echo() && event.is_pressed():
		if event.is_action("jump"):
			get_node("Enter").play("enter")
		elif event.is_action("restart"):
			get_node("Enter").play("enter")
		elif event.type == InputEvent.KEY && event.scancode == KEY_F3:
			global.music = !global.music
		elif event.type == InputEvent.KEY && event.scancode == KEY_F9 or event.is_action("ui_cancel"):
			get_tree().quit()
		elif event.type == InputEvent.KEY && event.scancode == KEY_T && global.debug:
			global.level = 0
			get_tree().change_scene("res://scenes/main.tscn")

func _on_AnimationPlayer_finished():
	if get_node("Enter").get_current_animation() == "enter":
		get_tree().change_scene("res://scenes/main.tscn")

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
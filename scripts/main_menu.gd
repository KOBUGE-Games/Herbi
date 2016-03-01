extends Node2D

func _ready():
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
			get_tree().change_scene("res://scenes/between.tscn")
		elif event.is_action("restart"):
			get_tree().change_scene("res://scenes/between.tscn")
		elif event.type == InputEvent.KEY && event.scancode == KEY_F3:
			global.music = !global.music
		elif event.type == InputEvent.KEY && event.scancode == KEY_F9:
			get_tree().quit()
		elif event.type == InputEvent.KEY && event.scancode == KEY_T && global.debug:
			global.level = 0
			get_tree().change_scene("res://scenes/main.tscn")
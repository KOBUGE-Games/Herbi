extends Node2D

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump"):
		start()

func start():
	if get_name() == "Keys":
		get_tree().change_scene("res://scenes/main.tscn")
	else:
		get_tree().change_scene("res://scenes/main_menu.tscn")

func play_sound(sample):
	global.play_sound(sample)
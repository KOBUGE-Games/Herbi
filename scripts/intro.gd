extends Node2D

func play_sound(sample):
	global.play_sound(sample)

func start():
	get_tree().change_scene("res://scenes/main_menu.tscn")
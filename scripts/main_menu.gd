extends Node2D

func _ready():
	global.level = 1
	global.score = 0
	global.lives = 3

func _on_play_pressed():
	get_tree().change_scene("res://scenes/between.tscn")

extends Node2D

func _ready():
	pass

func _on_play_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

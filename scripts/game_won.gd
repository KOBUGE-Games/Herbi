extends Node2D

func _ready():
	set_process_input(true)
	
func _input(event):
	if not event.is_echo() && event.is_pressed():
		if event.is_action("ui_cancel"):
			get_tree().change_scene("res://scenes/main_menu.tscn")
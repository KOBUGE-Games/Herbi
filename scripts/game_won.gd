extends Node2D

func _ready():
	get_node("Stats").set_text(str("Final Score = ",str(global.final_score),"\nApples picked = ",str(global.apples_picked),"\nLifes lost = ",str(global.life_lost),"\nEnemies killed = ",str(global.enemies_killed)))
	set_process_input(true)

func _input(event):
	if not event.is_echo() && event.is_pressed():
		if event.is_action("ui_cancel"):
			quit()

func quit():
	get_tree().change_scene("res://scenes/main_menu.tscn")
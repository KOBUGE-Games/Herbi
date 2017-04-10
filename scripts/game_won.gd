extends Node2D

func _ready():
	get_node("Stats").set_text(str("Final Score = ",str(global.final_score),"\nApples picked = ",str(global.apples_picked),"\nLifes lost = ",str(global.life_lost),"\nTrials = ",str(global.deaths),"\nEnemies killed = ",str(global.enemies_killed)))
extends Node2D

var camera
var world_end
var level = load("res://levels/level_"+str(global.level)+".tscn")
var pLive = preload("res://scenes/hud/live.tscn")
var diamonds = 0
var collected_diamonds = 0
var shield = false

func _ready():
	add_child(level.instance())
	camera = get_node("player/Camera2D")
	get_node("hud/items").set_text(str(global.score))
	get_node("player").set_pos(global.player_pos[global.level-1])
	camera.set_limit(MARGIN_RIGHT, global.level_size[global.level-1][0])
	camera.set_limit(MARGIN_BOTTOM, global.level_size[global.level-1][1])
	update_lives(0)
	
func update_score(amount):
	global.score += amount
	if global.score == 100:
		update_lives(1)
		global.score = 0
	get_node("hud/items").set_text(str(global.score))
	
func update_lives(amount):
	if not shield:
		global.lives += amount
		if global.lives > 0:
			if amount == -1:
				shield = true
				get_node("player").set_opacity(0.5)
				get_node("shield").start()
			for el in get_node("hud/lives").get_children():
				el.queue_free()
			for i in range(global.lives):
				var live = pLive.instance()
				live.set_pos(Vector2(16+i*32,16))
				get_node("hud/lives").add_child(live)
		else:
			get_tree().change_scene("res://scenes/main_menu.tscn")
		
func add_diamond():
	diamonds += 1
	get_node("hud/diamonds").set_text("0/"+str(diamonds))
	
func collect_diamond():
	collected_diamonds += 1
	if collected_diamonds == diamonds:
		if global.level == global.total_levels:
			get_tree().change_scene("res://scenes/game_won.tscn")
		else:
			global.level += 1
			get_tree().change_scene("res://scenes/between.tscn")
		
	get_node("hud/diamonds").set_text(str(collected_diamonds)+"/"+str(diamonds))

func _on_shield_timeout():
	get_node("player").set_opacity(1)
	shield = false

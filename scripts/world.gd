extends Node2D

var world_end
var level = load("res://levels/level_"+str(global.level)+".tscn")
var pLive = preload("res://scenes/hud/live.tscn")
var diamonds = 0
var collected_diamonds = 0
var shield = false
var start_score = 0
var start_lives = 0

func _ready():
	add_child(level.instance())
	get_node("hud/items").set_text(str(global.score))
	update_lifes()
	start_score = global.score
	start_lives = global.lives
	if global.music:
		get_node("StreamPlayer").play()
	set_process_input(true)
	
func update_score(amount):
	get_node("SamplePlayer2D").play("pop")
	global.score += amount
	if global.score == 100:
		update_lives(1)
		global.score = 0
	get_node("hud/items").set_text(str(global.score))
	
func add_life():
	global.lives += 1
	get_node("SamplePlayer2D").play("healthgain")
	update_lifes()
	
func remove_life():
	if not shield:
		global.lives -= 1
		shield = true
		get_node("player").set_opacity(0.5)
		get_node("shield").start()
		get_node("SamplePlayer2D").play("damage")
		update_lifes()
	
func update_lifes():
	if global.lives > 0:
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
	get_node("SamplePlayer2D").play("pick")
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
	
func _input(event):
	if event.type == InputEvent.KEY && not event.is_echo() && event.is_pressed():
		if event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://scenes/main_menu.tscn")
		elif event.scancode == KEY_F2:
			global.score = start_score
			global.lives = start_lives
			get_tree().change_scene("res://scenes/between.tscn")
		elif event.scancode == KEY_F3:
			global.music = !global.music
			if global.music:
				get_node("StreamPlayer").play()
			else:
				get_node("StreamPlayer").stop()
		elif event.scancode == KEY_F9:
			get_tree().quit()
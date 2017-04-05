extends Node2D

const level_announcer = preload("res://scenes/misc/level_announcer.tscn")

var world_end
var level = load("res://levels/level_"+str(global.level)+".tscn")
var pLive = preload("res://scenes/hud/live.tscn")
var diamonds = 0
var shield = false
var start_score = 0
var start_lives = 3
var start_apples = 0
var can_move = true
var quit = false

var collected_diamonds = 0
var lives
var apples
var score

onready var Event = get_node("CanvasLayer/Event")
onready var tween = get_node("hud/Tween")
onready var sampleplayer = get_node("SamplePlayer")

onready var sprite_diamonds = get_node("hud/sprite_diamonds")
onready var sprite_apples = get_node("hud/sprite_apples")
onready var sprite_score = get_node("hud/sprite_score")

func _ready():
	score = global.score
	lives = global.lives
	if global.lives < start_lives:
		lives = start_lives
	apples = global.apples
	add_child(level_announcer.instance())
	add_child(level.instance())
	if global.music:
		get_node("StreamPlayer").play()
	update_lifes()
	check_items("diamonds")
	check_items("apples", apples)
	check_items("score", score)
	set_process_input(true)

func update_score(amount):
	score += amount
	if score == 50:
		add_life()
		score = 0
	sampleplayer.play("pop")
	check_items("score", score)

func add_life():
	lives += 1
	sampleplayer.play("healthgain")
	update_lifes()

func remove_life():
	if not shield and can_move:
		lives -= 1
		shield = true
		get_node("shield").start()
		get_node("player/Events").play("damage")
		sampleplayer.play("damage")
		update_lifes()

func update_lifes():
	if lives > 0:
### Update HUD
		for el in get_node("hud/lives").get_children():
			el.queue_free()
		for i in range(lives):
			var live = pLive.instance()
			live.set_pos(Vector2(16+i*16,16))
			get_node("hud/lives").add_child(live)
	else:
		get_node("player").dead = true
		stop(true)

func add_diamond():
### Add diamond at level load
	diamonds += 1
	check_items("diamonds")

func collect_diamond():
	sampleplayer.play("pick")
	collected_diamonds += 1
	if collected_diamonds == diamonds:
		if global.level == global.total_levels:
			get_tree().change_scene("res://scenes/game_won.tscn")
		else:
### Next level
			global.level += 1
			stop()
	check_items("diamonds")

func add_apple():
	apples += 1
	check_items("apples", apples)

func remove_apple():
	apples -= 1
	check_items("apples", apples)

func _on_shield_timeout():
### Connected to a timer
	shield = false

func restart():
### Do [restart/next] level, depending on if global.level was changed (look collect_diamond(), _on_Die_finished() and stop())
	global.score = score
	global.lives = lives
	global.apples = apples
	get_tree().reload_current_scene()
	can_move = true

func _input(event):
	if not event.is_echo() && event.is_pressed():
		if event.is_action("ui_cancel"):
			stop()
			quit = true
		elif event.is_action("restart"):
			stop()
		if event.type == InputEvent.KEY:
			if event.scancode == KEY_F3:
				global.music = !global.music
				if global.music:
					get_node("StreamPlayer").play()
				else:
					get_node("StreamPlayer").stop()
			elif event.scancode == KEY_F9:
				get_tree().quit()
			
			# DEBUG MODE
			if global.debug:
				if event.scancode == KEY_D:
					if global.level < global.total_levels:
						global.level += 1
						get_tree().change_scene("res://scenes/main.tscn")
				elif event.scancode == KEY_A:
					if global.level > 1:
						global.level -= 1
						get_tree().change_scene("res://scenes/main.tscn")
				elif event.scancode == KEY_W:
					add_life()
				elif event.scancode == KEY_S:
					remove_life()
				elif event.scancode == KEY_Q:
					add_apple()

func stop(die=false):
### Tweening color depending on [death/next level]
	var color
	if die:
		apples = 0
		color = Color(1, 0, 0, 0)
	else:
		color = Color(0, 0, 0, 0)
### Play the animation :
###  - tween to indicate the color (death/ next level)
###  - animation to make the transition. It is connected to _on_Die_finished()
	tween.interpolate_property(get_node("CanvasLayer/Sprite"), "modulate", color, Color(0, 0, 0, 1), 0.3, 0, 1)
	tween.start()
	Event.play("stop")
	can_move = false

func _on_Die_finished():
	if Event.get_current_animation() == "stop":
		if quit:
			get_tree().change_scene("res://scenes/main_menu.tscn")
		else:
			restart()


func check_items(item_name, item_num=0):
### The color of HUD items : Grey color if 0 items (off_color), Normal color else.
	var on_color = Color(1,1,1,1)
	var off_color = Color(0.6,1,1,0.6)
	if collected_diamonds > 0:
		sprite_diamonds.set_modulate(on_color)
	else:
		sprite_diamonds.set_modulate(off_color)
	if apples > 0:
		sprite_apples.set_modulate(on_color)
	else:
		sprite_apples.set_modulate(off_color)
	if score > 0:
		sprite_score.set_modulate(on_color)
	else:
		sprite_score.set_modulate(off_color)
	
### The rotating tween for HUD items
	tween.interpolate_property(get_node(str("hud/sprite_", item_name)), "transform/rot", 0, 360, 0.4, 1, 1)
	tween.start()
	
### The number of items
	if item_name == "diamonds":
		item_num = str(str(collected_diamonds), "/", str(diamonds))
	get_node(str("hud/", item_name)).set_text(str(item_num))
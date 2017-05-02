extends Node2D

const level_announcer = preload("res://scenes/misc/level_announcer.tscn")
const pLive = preload("res://scenes/hud/live.tscn")
const p_clouds = preload("res://scenes/misc/clouds.tscn")
var level = load("res://levels/level_"+str(global.level)+".tscn")

var world_end
var diamonds = 0
var shield = false
var start_score = 0
var start_lives = 3
var start_apples = 0
var can_move = true
var quit = false
var can_quit = false
var next_level = false

var collected_diamonds = 0
var lives
var apples
var score

var last_checkpoint = Vector2()
var respawned = true

onready var tween = get_node("hud/Tween")

onready var sprite_diamonds = get_node("hud/sprite_diamonds")
onready var sprite_apples = get_node("hud/sprite_apples")
onready var sprite_score = get_node("hud/sprite_score")

onready var transition = get_node("transition")

onready var player = get_node("player")
var window_size = Vector2(0,0)

func _ready():
	init_values()
	init_clouds()
	if global.is_music and not music.is_playing():
		music.play()
	transition.start((randi() % 2), false, (randi() % 2))
	add_child(level_announcer.instance())
	add_child(level.instance())
	last_checkpoint = player.get_pos()
	set_process_input(true)

func init_values():
	score = global.score
	lives = global.lives
	if lives < 3:
		lives = 3
	apples = global.apples
	if respawned:
		respawned = false
		start_lives = lives
		start_apples = apples
		start_score = score
	update_lifes()
	check_items("diamonds")
	check_items("apples", apples)
	check_items("score", score)

func update_score(amount):
	score += amount
	if score >= 250:
		add_life()
		score = 0
	global.play_sound("pop")
	check_items("score", score)

func add_life():
	lives += 1
	global.play_sound("healthgain")
	update_lifes()

func remove_life():
	if not shield and can_move:
		global.life_lost += 1
		lives -= 1
		shield = true
		get_node("shield").start()
		get_node("player/Events").play("damage")
		global.play_sound("damage")
		update_lifes()

func update_lifes():
	if lives > 0:
### Update HUD
		for node in get_node("hud/lives").get_children():
			if node extends Sprite:
				node.queue_free()
		if lives < 4:
			get_node("hud/lives/Label").hide()
			for i in range(lives):
				var live = pLive.instance()
				live.set_pos(Vector2(16+i*18,16))
				get_node("hud/lives").add_child(live)
		else:
			var live = pLive.instance()
			live.set_pos(Vector2(16,16))
			get_node("hud/lives/Label").set_text(str("x ",str(lives)))
			get_node("hud/lives/Label").show()
			get_node("hud/lives").add_child(live)
	else:
		player.dead = true
		stop()

func add_diamond():
### Add diamond at level load
	diamonds += 1
	check_items("diamonds")

func collect_diamond():
	collected_diamonds += 1
	if collected_diamonds == diamonds:
### launches next_level tween. For more, go to _on_Die_finished()
		stop(true)
	update_values()
	global.play_sound("pick")
	check_items("diamonds")

func add_apple():
	apples += 1
	global.play_sound("pop")
	check_items("apples", apples)

func remove_apple():
	apples -= 1
	global.play_sound("throw")
	check_items("apples", apples)

func _on_shield_timeout():
### Connected to a timer
	shield = false

func restart():
### Does [restart/next] level, depending on if global.level was changed (look collect_diamond(), _on_Die_finished() and stop())
	can_move = true
	if player.dead:
		player.set_pos(last_checkpoint)
		player.dead = false
		player.out = false
		get_node("hud/menu").disable(false)
		init_values()
		transition.start((randi() % 2), false, (randi() % 2))
	else:
		get_tree().reload_current_scene()

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_S:
			remove_life()
		if not event.is_echo() && event.is_pressed():
			# DEBUG MODE
			if global.debug:
				if event.scancode == KEY_D:
					if global.level < global.total_levels:
						stop(true)
				elif event.scancode == KEY_A:
					if global.level > 1:
						global.level -= 1
						get_tree().change_scene("res://scenes/main.tscn")
				elif event.scancode == KEY_W:
					add_life()
				elif event.scancode == KEY_Q:
					add_apple()
				elif event.scancode == KEY_E:
					collect_diamond()
				elif event.scancode == KEY_F9:
					get_tree().quit()

func update_values():
	global.score = score
	global.lives = lives
	global.apples = apples

func stop(condition=false):
### Tweening color depending on [death/next level]
	if condition:
		update_values()
		next_level = condition
	else:
		if not quit:
			global.deaths += 1
### Play the animation :
###  - tween to indicate the color (death/ next level)
###  - animation to make the transition. It is connected to _on_Die_finished()
	transition.connect("finished_anim", self, "change_level", Array(), 4)
	transition.start((randi() % 2), true, (randi() % 2))
	can_move = false

func change_level():
	if quit:
		get_tree().change_scene("res://scenes/main_menu.tscn")
	else:
### Changing level/ending the game
### You can see you don't gain a level in collect_diamond().
### That's because we used this location for a proper tweening
		if next_level:
			if global.level == global.total_levels:
				global.finished = true
				get_tree().change_scene("res://scenes/main_menu.tscn")
			else:
				global.level += 1
				restart()
		else:
			restart()


func check_music():
	if global.is_music:
		music.play()
	else:
		music.stop()


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

func init_clouds():
	var amount = (randi() % 2) + 2
	for i in range(amount):
		var cloud = p_clouds.instance()
		cloud.set_pos(Vector2(randi() % 300,randi() % 230))
		get_node("clouds").add_child(cloud) 
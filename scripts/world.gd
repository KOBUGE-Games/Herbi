extends Node2D

const level_announcer = preload("res://scenes/misc/level_announcer.tscn")
const pLive = preload("res://scenes/hud/live.tscn")
const p_clouds = preload("res://scenes/misc/clouds.tscn")

var level = load("res://levels/"+global.level_name+str(global.level)+".tscn")
var level_node

var world_end
var diamonds = 0
var shield = false
var start_score = 0
var start_lives = 3
var start_apples = 0
var can_move = true
var quit = false
var next_level = false

var collected_diamonds = 0
var lives
var apples
var score

var hidden_bg = false

onready var tween = get_node("hud/Tween")

onready var sprite_diamonds = get_node("hud/sprite_diamonds")
onready var sprite_apples = get_node("hud/sprite_apples")
onready var sprite_score = get_node("hud/sprite_score")

onready var transition = get_node("transition/Node2D")

onready var player = get_node("player")
var window_size = Vector2(0,0)

func _ready():
	init_values()
	init_clouds()
	transition.queue_transition((randi() % 2), false, (randi() % 2))
	add_child(level_announcer.instance())
	if level != null:
		if global.level > 1: #works for level 1 and 0
			save_manager.temporary_events.level_error = false
		level_node = level.instance()
		add_child(level_node)
	else:
		save_manager.temporary_events.level_error = true
		print("level_error")
		get_tree().change_scene("res://scenes/main_menu.tscn")
	player.last_checkpoint = player.get_pos()

func init_values():
	score = global.score
	apples = global.apples
	lives = global.lives
	if lives < 3:
		lives = 3
	
	start_lives = lives
	start_apples = apples
	start_score = score
	
	update_lifes()
	
	background.update_state()
	get_node("/root/events_texts").update()
	
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
	if lives < 66: #Needs some devilish easter-egg
		lives += 1
		global.play_sound("healthgain")
		update_lifes()

func remove_life():
	if not shield and not quit:
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
	if not is_processing():
		set_process(true)

func collect_diamond():
	collected_diamonds += 1
	if collected_diamonds == diamonds:
### launches next_level tween. For more, go to _on_Die_finished()
		stop(true)
	update_values()
	global.play_sound("pick")
	check_items("diamonds")

func add_apple():
	if apples < 66: #Needs some devilish easter-egg there too
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
		player.respawn()
		get_node("hud/menu").disable(false)
		init_values()
		transition.queue_transition((randi() % 2), false, (randi() % 2))
	else:
		get_tree().reload_current_scene()


func update_values():
	global.score = score
	global.lives = lives
	global.apples = apples

func stop(condition=false, level_name='', cave=false):
### Tweening color depending on [death/next level]
	if events_texts.writing:
		events_texts.abort = true
		events_texts.emit_signal("continue_dialog")
	if condition:
		update_values()
		next_level = condition
	else:
		if not quit:
			global.deaths += 1
### Play the animation :
###  - tween to indicate the color (death/ next level)
###  - animation to make the transition. It is connected to _on_Die_finished()
	var connections = [self, "change_level", [level_name]]
	if cave:
		transition.queue_transition(2, true, 0, connections)
	else:
		transition.queue_transition((randi() % 2), true, (randi() % 2), connections)
	can_move = false

func change_level(level_name):
	if quit:
		get_tree().change_scene("res://scenes/main_menu.tscn")
	else:
### Changing level/ending the game
### You can see you don't gain a level in collect_diamond().
### That's because we used this location for a proper tweening
		if level_name != '':
			global.level_name = level_name
			restart()
		else:
			if next_level:
				if global.level == global.total_levels:
					global.finished = true
					get_tree().change_scene("res://scenes/main_menu.tscn")
				else:
					global.level += 1
					restart()
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

func init_clouds():
	var amount = (randi() % 2) + 2
	for i in range(amount):
		var cloud = p_clouds.instance()
		cloud.set_pos(Vector2(randi() % 300,randi() % 230))
		get_node("clouds").add_child(cloud)

func hide_back(param=false):
	for child in level_node.get_node("back").get_children():
		if param == false:
			child.show()
		else:
			child.hide()
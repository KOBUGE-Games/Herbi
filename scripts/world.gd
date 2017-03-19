extends Node2D

const level_announcer = preload("res://scenes/misc/level_announcer.tscn")

var world_end
var level = load("res://levels/level_"+str(global.level)+".tscn")
var pLive = preload("res://scenes/hud/live.tscn")
var diamonds = 0
var collected_diamonds = 0
var shield = false
var start_score = 0
var start_lives = 0
var start_apples = 0
var can_move = true
var quit = false

onready var Event = get_node("CanvasLayer/Event")
onready var tween = get_node("hud/Tween")

onready var sprite_diamonds = get_node("hud/sprite_diamonds")
onready var sprite_apples = get_node("hud/sprite_apples")
onready var sprite_items = get_node("hud/sprite_items")

func _ready():
	check_items()
	add_child(level_announcer.instance())
	add_child(level.instance())
	get_node("hud/items").set_text(str(global.score))
	get_node("hud/apples").set_text(str(global.apples))
	update_lifes()
	start_score = global.score
	start_lives = global.lives
	start_apples = global.apples
	if global.music:
		get_node("StreamPlayer").play()
	set_process_input(true)

func update_score(amount):
	get_node("SamplePlayer").play("pop")
	global.score += amount
	if global.score == 50:
		add_life()
		global.score = 0
	get_node("hud/items").set_text(str(global.score))
	hud_add_item(sprite_items)
	check_items()

func add_life():
	global.lives += 1
	get_node("SamplePlayer").play("healthgain")
	update_lifes()

func remove_life():
	if not shield and can_move:
		get_node("/root/world/SamplePlayer").play("damage")
		global.lives -= 1
		shield = true
		get_node("shield").start()
		get_node("player/Events").play("damage")
		get_node("SamplePlayer").play("damage")
		update_lifes()

func update_lifes():
	if global.lives > 0:
		for el in get_node("hud/lives").get_children():
			el.queue_free()
		for i in range(global.lives):
			var live = pLive.instance()
			live.set_pos(Vector2(16+i*16,16))
			get_node("hud/lives").add_child(live)
	else:
		stop(true)

func add_diamond():
	diamonds += 1
	get_node("hud/diamonds").set_text("0/"+str(diamonds))

func collect_diamond():
	get_node("SamplePlayer").play("pick")
	collected_diamonds += 1
	if collected_diamonds == diamonds:
		if global.level == global.total_levels:
			get_tree().change_scene("res://scenes/game_won.tscn")
		else:
			global.level += 1
			stop()
	
	hud_add_item(sprite_diamonds)
	check_items()
	get_node("hud/diamonds").set_text(str(collected_diamonds)+"/"+str(diamonds))

func add_apple():
	global.apples +=1
	get_node("hud/apples").set_text(str(global.apples))
	hud_add_item(sprite_apples)
	check_items()

func remove_apple():
	global.apples -=1
	get_node("hud/apples").set_text(str(global.apples))
	check_items()

func _on_shield_timeout():
	shield = false

func restart():
		global.score = start_score
		global.lives = start_lives
		global.apples = start_apples
		get_tree().reload_current_scene()
		can_move = true

func hud_add_item(item):
	tween.interpolate_property(item, "transform/rot", 0, 360, 0.4, 1, 1)
	tween.start()

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
	var color
	if die:
		color = Color(1, 0, 0, 0)
	else:
		color = Color(0, 0, 0, 0)
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

func check_items():
	var on_color = Color(1,1,1,1)
	var off_color = Color(0.6,1,1,0.6)
	if collected_diamonds > 0:
		sprite_diamonds.set_modulate(on_color)
	else:
		sprite_diamonds.set_modulate(off_color)
	
	if global.apples > 0:
		sprite_apples.set_modulate(on_color)
	else:
		sprite_apples.set_modulate(off_color)
	
	if global.score > 0:
		sprite_items.set_modulate(on_color)
	else:
		sprite_items.set_modulate(off_color)
extends Node2D

var camera
var world_end
var level = preload("res://levels/level.tscn")
var pLive = preload("res://scenes/hud/live.tscn")
var score = 0
var lives = 3
var diamonds = 0
var collected_diamonds = 0

func _ready():
	add_child(level.instance())
	camera = get_node("player/Camera2D")
	world_end = get_node("world_end").get_pos()-Vector2(16,4)
	camera.set_limit(MARGIN_RIGHT, world_end.x)
	camera.set_limit(MARGIN_BOTTOM, world_end.y)
	update_lives(0)
	
func update_score(amount):
	score += amount
	if score == 10:
		update_lives(1)
		score = 0
	get_node("hud/items").set_text(str(score))
	
func update_lives(amount):
	lives += amount
	for el in get_node("hud/lives").get_children():
		el.queue_free()
	for i in range(lives):
		var live = pLive.instance()
		live.set_pos(Vector2(16+i*32,16))
		get_node("hud/lives").add_child(live)
		
func add_diamond():
	diamonds += 1
	get_node("hud/diamonds").set_text("0/"+str(diamonds))
	
func collect_diamond():
	collected_diamonds += 1
	get_node("hud/diamonds").set_text(str(collected_diamonds)+"/"+str(diamonds))
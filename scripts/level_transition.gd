extends CanvasLayer

signal finished_anim()

var i
var j
var ratio

onready var timer = get_node("Timer")

###### a procedural animation script
### param == 0: vertical
### param == 1: horizontal
### mode == 0: linear anim
### mode == 1: [from/to] center anim

func init_scale(param):
	for sprite in get_children():
		if sprite.get_name().begins_with("bar"):
			if param == 0:
				sprite.set_scale(Vector2(40, 240))
			elif param == 1:
				sprite.set_scale(Vector2(320, 40))

func init_pos(param):
	init_scale(param)
	i = 0
	var random = randi() % 2
	var b = 0
	if random == 1:
		if param == 0:
			b = 280
		elif param == 1:
			b = 200
	for i in range(8):
		i += 1
		if param == 0:
			get_node(str("bar", str(i))).set_pos(Vector2(b, 0))
		elif param == 1:
			get_node(str("bar", str(i))).set_pos(Vector2(0, b))
		
		if random == 0:
			b += 40
		else:
			b -= 40

func show_elements(yes=true, mode=0):
	if i < ratio:
		i += 1
		if mode == 1:
			j -= 1
		if yes:
			get_node(str("bar", str(i))).show()
			if mode == 1:
				print("level_transition.gd : I don't work properly")
				get_node(str("bar", str(j))).show()
		else:
			get_node(str("bar", str(i))).hide()
			if mode == 1:
				get_node(str("bar", str(j))).hide()
		timer.start()
	else:
		if yes:
			get_node("bg").show()
		timer.disconnect("timeout", self, "show_elements")
		emit_signal("finished_anim")
		get_parent().can_quit = true

func start(param, no=false, mode=0):
	get_parent().can_quit = false
	if param != 0 and param != 1:
		print("wrong value")
	else:
		init_pos(param)
		if not no:
			get_node("bg").hide()
		i = 0
		ratio = 8
		if mode == 1:
			timer.set_wait_time(0.07)
			j = 9
			ratio = 4
			if param == 1:
				ratio = 3
				j = 7
		else:
			timer.set_wait_time(0.05)
		timer.start()
		timer.connect("timeout", self, "show_elements", [no, mode])
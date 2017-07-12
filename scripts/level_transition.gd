extends CanvasLayer

signal finished_anim()

var i
var j
var ratio

const bar_class = preload("res://scenes/misc/bar.tscn")
onready var timer = get_node("Timer")

var bars = []

###### a procedural animation script
### param == 0: vertical
### param == 1: horizontal
### param == 2: cave effect
### mode == 0: linear anim
### mode == 1: [from/to] center anim

func init_scale(param, showing): ###Init the scale of the 6/8 bars that are gonna be used
	var amount = 8
	var scale = Vector2(40, 240)
	if param == 1:
		amount = 6
		scale = Vector2(320, 40)
	elif param == 2:
		amount = 1
		scale = Vector2(320, 240)
	
	for i in range(amount):
		var bar = bar_class.instance()
		bar.set_scale(scale)
		if showing:
			bar.hide()
		get_node("bars").add_child(bar)
		bars.append(bar)


func init_pos(param, showing):
	init_scale(param, showing)
	var order = 0 ### Init the order of progression
	if param != 2:
		order = randi()%2
	var b = 280*order ### Left to Right or Right to Left
	if param == 1:
		b = 200*order ### Top to Down or Down to Top
	
	for bar in bars: ### Set the pos in the right order defined before
		if param == 0:
			bar.set_pos(Vector2(b, 0))
		else:
			bar.set_pos(Vector2(0, b))
		if order == 0:
			b += 40
		else:
			b -= 40


func show_elements(showing=true, mode=0, param=0):
	if i < ratio:
		if param == 2: ### Cave transition
			i += 1
			if showing:
				bars[0].set_opacity(i/4.0)
			else:
				bars[0].set_opacity(1 - i/4)
			bars[0].show()
		else:
			if mode == 1:
				j -= 1
			
			if showing:
				bars[i].show()
				if mode == 1:
					bars[j].show()
			else:
				bars[i].hide()
				if mode == 1:
					bars[j].hide()
			i += 1
		global.play_sound("frp")
		timer.start()
	else:
		if showing:
			get_node("bg").show()
		bars.clear()
		for node in get_node("bars").get_children():
			node.queue_free()
			
		timer.disconnect("timeout", self, "show_elements")
		emit_signal("finished_anim")
		get_parent().can_quit = true

func start(param, showing=false, mode=0):
	get_parent().can_quit = false
	if not [0, 1, 2].has(param):
		print("wrong value")
	else:
		init_pos(param, showing)
		if not showing:
			get_node("bg").hide()
		
		i = 0
		ratio = 8
		if param == 2:
			ratio = 4
			timer.set_wait_time(0.2)
		else:
			if param == 1:
				ratio = 6
			
			if mode == 1:
				timer.set_wait_time(0.15)
				if param == 0:
					j = 8
					ratio = 4
				else:
					ratio = 3
					j = 6
			else:
				timer.set_wait_time(0.1)
		
		timer.start()
		timer.connect("timeout", self, "show_elements", [showing, mode, param])
extends Node2D

signal finished_anim

var playing = false

var i
var j
var ratio
var side = 0 #used only for CAVE param
var stored_rects = []

const bar_class = preload("res://scenes/misc/bar.tscn")
onready var timer = get_node("Timer")
var bars = []

enum {
	VERTICAL = 0,
	HORIZONTAL = 1,
	CAVE = 2
}

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
		if param == CAVE: ### Cave transition
#			i += 1
#			if showing:
#				bars[0].set_opacity(i/4.0)
#			else:
#				bars[0].set_opacity(1 - i/4)
#			bars[0].show()

			side += 1
			if side > 4:
				side = 1
				i += 1

			var x_side
			var y_side
			if side == 1:
				y_side = -1
				x_side = -1
			elif side == 2:
				y_side = -1
				x_side = 1
			elif side == 3:
				y_side = 1
				x_side = 1
			elif side == 4:
				y_side = 1
				x_side = -1

			var anchor1 = Vector2(160+40*(ratio-i)*x_side, 120+30*(ratio-i)*y_side)
			var anchor2 = Vector2()
			if [1,3].has(side):
				anchor2 = Vector2(320*(-x_side), 30*(-y_side))
			elif [2,4].has(side):
				anchor2 = Vector2(40*(-x_side), 240*(-y_side))
			else:
				print("what the fuck did you do wrong with that value m8")

			stored_rects.append([anchor1, anchor2])
			update()

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
		stored_rects.clear()
		update()
		for node in get_node("bars").get_children():
			node.queue_free()

		timer.disconnect("timeout", self, "show_elements")
		if not get_parent().get_name() == "world" or not events_texts.writing:
			global.can_quit = true
		playing = false
		emit_signal("finished_anim")

func start(param, showing=false, mode=0, connects=[]):
	if not playing:
		stored_rects.clear()
		global.can_quit = false
		playing = true
		if not [0, 1, 2].has(param):
			print("wrong parameter for transition")
		else:
			init_pos(param, showing)
			if not showing:
				get_node("bg").hide()

			i = 0
			ratio = 8
			if param == CAVE:
				ratio = 4
				timer.set_wait_time(0.1)
			else:
				if param == HORIZONTAL:
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
			if connects != []:
				connect("finished_anim", connects[0], connects[1], connects[2], 4)

func queue_transition(param, showing=false, mode=0, connects=[]):
	if playing and not is_connected("finished_anim", self, "start"):
		connect("finished_anim", self, "start", [param, showing, mode, connects], 4)
	else:
		start(param, showing, mode, connects)

func _draw():
	for rect in stored_rects:
		draw_rect(Rect2(rect[0], rect[1]), Color(0,0,0))
extends Node2D

signal finished_line
signal finished_writing

const font = preload("res://fonts/cave_story_32.fnt")
const button_res = preload("res://scenes/hud//buttons/button.tscn")

var text_lenght
var timer
var i
var paused = false

### Permits to create dialog lines
# var text1 = [
#	"this is an example",
#	"text",
#	"",
#	"button indeed",
#	"button not at all"
#]

func _input(event):
	if event.is_action_pressed("jump"):
		i = text_lenght

func new_line(text, pos): ### Create the text line
	var label = Label.new()
	label.set_scale(Vector2(0.6, 0.6))
	label.set_size(Vector2(533, 20))
	label.set_align(1)
	label.set("custom_fonts/font", font)
	label.set("custom_colors/font_color", Color(0.9, 0.95, 1))
	label.set_pos(Vector2(0, pos))
	get_node("text").add_child(label)
	
	var text_timer = global.new_timer(0.03125)
	add_child(text_timer)
	
	text_lenght = text.length()
	i = 0
	text_timer.connect("timeout", self, "write_next", [text, label, text_timer])
	text_timer.start()
	set_process_input(true)

func write_next(text, label, text_timer):
	if not paused and not get_parent().abort:
		i += 1
		label.set_text(text.substr(0, i))
		global.play_sound("tic")
		text_timer.start()
		
		if i >= text_lenght:
			set_process_input(false)
			text_timer.queue_free()
			emit_signal("finished_line")
	else:
		text_timer.start()

func new_text(text_array, pos): ### Display the text screen
	timer = global.new_timer(0.5)
	add_child(timer)
	create_text(text_array, pos, 0)

func create_text(text_array, pos, j): ### Create the text screen
	if j <= (text_array.size() - 1):
		var t = text_array[j]
		if typeof(t) == TYPE_ARRAY:
			new_button(t[0], (pos + 20+(j-1)*46))
			get_node("buttons/"+t[0]).connect("pressed", get_parent(), t[1])
		else:
			new_line(t, (pos + j*15))
		yield(self, "finished_line")
		j +=1
		create_text(text_array, pos, j)
	else:
		get_parent().check_buttons()
		emit_signal("finished_writing")

func new_button(text, pos): ### Create a button
	var button = button_res.instance()
	button.set_name(text)
	button.name = text
	button.set_pos(Vector2(80, pos))
	button.set_scale(Vector2(5, 5))
	button.connect("pressed", get_parent().world.get_node("button_select/Node2D"), "set_active", [null, false], 4)
	get_node("buttons").add_child(button)
	timer.start()
	global.play_sound("click")
	yield(timer, "timeout")
	emit_signal("finished_line")

func destroy(): ### Destroys all the existing text contents
	for nodes in get_children():
		for node in nodes.get_children():
			node.queue_free()
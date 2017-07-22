extends Node2D

signal finished_line
signal finished_writing

const font = preload("res://fonts/cave_story_32.fnt")
const button_res = preload("res://scenes/hud/button.tscn")

var text_lenght
var timer
var i

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
	label.set("custom_colors/font_color_shadow", Color(0.2, 0.2, 0.2))
	label.set_pos(Vector2(0, pos))
	add_child(label)
	
	var text_timer = Timer.new()
	text_timer.set_one_shot(1)
	text_timer.set_wait_time(0.03125)
	add_child(text_timer)
	
	text_lenght = text.length()
	i = 0
	text_timer.connect("timeout", self, "write_next", [text, label, text_timer])
	text_timer.start()
	set_process_input(true)

func write_next(text, label, text_timer):
	i += 1
	label.set_text(text.substr(0, i))
	text_timer.start()
	
	if i >= text_lenght:
		set_process_input(false)
		text_timer.queue_free()
		emit_signal("finished_line")

func new_text(text_array, pos): ### Display the text screen
	timer = Timer.new()
	timer.set_name("Timer")
	timer.set_wait_time(0.5)
	timer.set_one_shot(1)
	add_child(timer)
	create_text(text_array, pos, 0)

func create_text(text_array, pos, j): ### Create the text screen
	if j <= (text_array.size() - 1):
		var t = text_array[j]
		if typeof(t) == TYPE_ARRAY:
			new_button(t[0], (pos + j*30))
			get_node(t[0]).connect("pressed", get_parent(), t[1])
		else:
			new_line(t, (pos + j*15))
		if typeof(t) == TYPE_STRING and t != "":
			global.play_sound("click")
		yield(self, "finished_line")
		j +=1
		create_text(text_array, pos, j)
	else:
		emit_signal("finished_writing")

func new_button(text, pos): ### Create a button
	var button = button_res.instance()
	button.set_name(text)
	button.set_text(text)
	button.set_pos(Vector2(0, pos))
	button.set("custom_fonts/font", font)
	add_child(button)
	timer.start()
	yield(timer, "timeout")
	emit_signal("finished_line")

func destroy(): ### Destroys all the existing text contents
	for node in get_children():
		node.queue_free()
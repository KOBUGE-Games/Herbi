extends Node2D

signal finished_writing

const font = preload("res://fonts/cave_story_32.fnt")
const button_res = preload("res://scenes/hud/button.tscn")

var timer

### Permits to create dialog lines
# var text1 = [
#	"this is an example",
#	"text",
#	"",
#	"button indeed",
#	"button not at all"
#]

func new_line(text, pos):
	var label = Label.new()
	label.set_scale(Vector2(0.6, 0.6))
	label.set_size(Vector2(533, 20))
	label.set_align(1)
	label.set("custom_fonts/font", font)
	label.set("custom_colors/font_color", Color(0.9, 0.95, 1))
	label.set("custom_colors/font_color_shadow", Color(0.2, 0.2, 0.2))
	label.set_pos(Vector2(0, pos))
	label.set_text(text)
	add_child(label)

func new_text(text_array, pos):
	timer = Timer.new()
	timer.set_name("Timer")
	timer.set_wait_time(0.5)
	timer.set_one_shot(1)
	add_child(timer)
	create_text(text_array, pos, 0)

func create_text(text_array, pos, i):
	if i <= (text_array.size() - 1):
		var t = text_array[i]
		if typeof(t) == TYPE_ARRAY:
			new_button(t[0], (pos + i*30))
			get_node(t[0]).connect("pressed", get_parent(), t[1])
		else:
			new_line(t, (pos + i*15))
		if typeof(t) == TYPE_STRING and t != "":
			global.play_sound("click")
		timer.start()
		yield(timer, "timeout")
		i +=1
		create_text(text_array, pos, i)
	else:
		emit_signal("finished_writing")

func new_button(text, pos):
	var button = button_res.instance()
	button.set_name(text)
	button.set_text(text)
	button.set_pos(Vector2(0, pos))
	button.set("custom_fonts/font", font)
	add_child(button)

func destroy():
	for node in get_children():
		node.queue_free()
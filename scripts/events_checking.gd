extends Node

signal continue_dialog
signal text_finished

var text1 = ["Hey !", "Stop !"]
var text2 = ["What are you hoping", "doing those levels again and again ?"]
var text3 = ["Oh right, you probably", "followed that flickering button", "but you know, all of that,", "was totally scripted"]
var text4 = ["Anyway, I'd like to show you", "something pretty interesting"]
var text5 = ["Do you want to check it out ?", ["yes", "event_yes"], ["no", "event_no"]]

var text6 = ["Alright, I might ask you later", "", "Have fun", "", "If you can"]

var text7 = ["I forgot to tell you"]
var text8 = ["If you start going around the debug stuff"]
var text9 = ["The systems might not be as before", "So think about how to use your new powers"]

var text10 = ["so far so good,","this is what I have done so far"]
var text11 = ["I had not really any idea", "of what to do,", "so I started experimenting stuff"]
var text12 = ["I don't really know", "why I'm telling this,", "but anyway", "..."]
var text13 = ["..."]
var text14 = ["By the way, there was an", "old loading screen"]
var text15 = ["It looked a bit like this"]


var can_skip = false

onready var world = get_node("/root/world")
onready var event = get_node("event")

func _ready():
	event.connect("finished_writing", self, "set", ["can_skip", true])
	connect("text_finished", world, "set", ["can_move", true])
	set_process_input(true)
	if global.level == 1 and save_manager.progression.first_finish and not save_manager.progression.first_contact:
		write_texts([text1, text2, text3, text4, text5], [100, 100, 80, 100, 80])
	
	if not save_manager.progression.level_error_message:
		if(save_manager.temporary_events.debug_next_level and global.level == 1) or save_manager.temporary_events.level_error:
			write_texts([text7, text8, text9],[110, 110, 100])
			yield(self, "text_finished")
			save_manager.progression.level_error_message = true
	
	if global.level == 4 and global.level_name == "devel_" and not save_manager.progression.devel_4_message:
		write_texts([text10, text11, text12, text13, text14, text15], [100, 90, 80, 110, 100, 110])
		yield(self, "text_finished")
		save_manager.progression.devel_4_message = true
	
	save_manager.temporary_events.debug_next_level = false

func write_texts(texts_array, texts_pos_array):
	world.writing = true
	for i in range(texts_array.size()):
		can_skip = false
		world.can_move = false
		event.new_text(texts_array[i], texts_pos_array[i])
		yield(self, "continue_dialog")
		event.destroy()
		if i == (texts_array.size() - 1):
			emit_signal("text_finished")
			global.can_quit = true

func _input(event):
	if event.is_action_pressed("jump") and can_skip:
		emit_signal("continue_dialog")

func event_yes():
	event.destroy()
	global.debug = true
	save_manager.progression.first_contact = true
	world.quit = true
	world.stop()

func event_no():
	event.destroy()
	write_texts([text6], [70])
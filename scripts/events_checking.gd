extends Node

signal continue_dialog
signal text_finished

var in_game = false
var abort = false
var writing = false
var can_end = false
var can_skip = false
var shouldnt_move = false # Overrides can_move in player.gd

var world = ""
onready var event = get_node("event")

# You're probably gonna die trying to understand how that works

var text1 = ["Hey !", "Stop !"]
var text2 = ["What are you hoping", "doing those levels again and again ?"]
var text3 = ["Oh right, you probably", "followed that flickering button", "but you know, all of that,", "was totally scripted"]
var text4 = ["Anyway, I'd like to show you", "something pretty interesting"]
var text5 = ["Do you want to check it out ?", ["yes", "event_yes"], ["no", "event_no"]]

var text6 = ["Alright, I might ask you later", "", "Have fun", "", "If you can"]

var text7 = ["I forgot to tell you"]
var text8 = ["If you start going around the debug stuff"]
var text9 = ["The systems might not be as before", "So think about how to use your new powers"]

var text10 = ["Glad you did it"]
var text11 = ["Now, you're gonna enter", "another dimension of", "what this place is"]
var text12 = ["I don't really have", "much more to tell you about"]
var text13 = ["..."]
var text14 = ["There was an old", "loading screen"]
var text15 = ["It looked a bit this way"]


func check_music():
	if save_manager.config.music:
		if global.level >= 1 and global.level_name == "level_":
			global.play_music("music_1")
		else:
			global.play_music("mysterious")
	else:
		global.stop_music()

func update():
	global.debug = false
	abort = false
	if save_manager.progression.first_finish and save_manager.progression.first_contact:
		global.debug = true

	if event.is_connected("finished_writing", self, "set"):
		event.disconnect("finished_writing", self, "set")


	for object in get_node("/root/").get_children():
		if object.get_name() == "menu":
			in_game = false
			break
		else:
			in_game = true

	if in_game:
		world = get_node("/root/world")
		check_music()
		event.connect("finished_writing", self, "set", ["can_skip", true])
		set_process_input(true)
		if global.level == 1 and save_manager.progression.first_finish and not save_manager.progression.first_contact:
			shouldnt_move = true
			write_texts([text1, text2, text3, text4, text5], [100, 100, 80, 100, 80])
			yield(self, "text_finished")

		if not save_manager.progression.level_error_message:
			if(save_manager.temporary_events.debug_next_level and global.level == 1) or save_manager.temporary_events.level_error:
				write_texts([text7, text8, text9],[110, 110, 100])
				yield(self, "text_finished")
				save_manager.progression.level_error_message = true

		if global.level == 4 and global.level_name == "devel_" and not save_manager.progression.devel_4_message:
			shouldnt_move = true
			write_texts([text10, text11, text12, text13, text13, text14, text15], [110, 90, 100, 110, 110, 100, 110])
			yield(self, "text_finished")
			save_manager.progression.devel_4_message = true

		save_manager.temporary_events.debug_next_level = false

func check_buttons():
	if event.get_node("buttons").get_child_count() >= 1 and not world.get_node("hud/menu").shown:
		world.get_node("button_select/Node2D").buttons_dir = event.get_node("buttons")
		world.get_node("button_select/Node2D").set_active(null, true)


func write_texts(texts_array, texts_pos_array):
	writing = true
	for i in range(texts_array.size()):
		can_skip = false
		event.new_text(texts_array[i], texts_pos_array[i])
		yield(self, "continue_dialog")
		event.destroy()
		if i == (texts_array.size() - 1):
			emit_signal("text_finished")
			can_end = true
		elif abort:
			abort = false
			emit_signal("text_finished")
			event.destroy()
			can_end = true
			break

func write_info(texts_array, texts_pos_array, destroy=false):
	writing = true
	for i in range(texts_array.size()):
		can_skip = false
		event.new_text(texts_array[i], texts_pos_array[i])
		yield(self, "continue_dialog")
		event.destroy()
		if i == (texts_array.size() - 1):
			emit_signal("text_finished")
			can_end = true


func _input(event):
	if event.is_action_released("jump") and can_end:  # prevents player from jumping
		can_end = false
		shouldnt_move = false
		writing = false
	elif event.is_action_pressed("jump") and can_skip and in_game:
		if not world.get_node("hud/menu").shown and not world.get_node("hud/menu/AnimationPlayer").is_playing():
			emit_signal("continue_dialog")

func event_yes():
	event.destroy()
	save_manager.progression.first_contact = true
	world.quit = true
	world.stop()

func event_no():
	event.destroy()
	write_texts([text6], [70])
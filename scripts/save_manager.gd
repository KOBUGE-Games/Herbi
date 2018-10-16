extends Node

const default_config = {
	music = true,
	sound = true,
	fullscreen = false
}

const events = {
	first_finish = false,
	debug = false,
	level_error_message = false,
	devel_4_message = false
}

var temporary_events = { ### Events that aren't saved
	debug_next_level = false,
	level_error = false
}

var config = {}
var progression = {}

func _ready():
	load_game()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		global.quit()

func load_game():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://Herbi.save", File.READ, "Herbi")
	
	if !err:
		config = f.get_var()
		progression = f.get_var()
	
	if config == null:
		config = default_config
	else:
		for option in default_config:
			if !config.has(option):
				config[option] = default_config[option]
	
	if progression == null:
		progression = events
	else:
		for option in events:
			if !progression.has(option):
				progression[option] = events[option]
		for option in progression:
			if !events.has(option):
				progression.erase(option)
	
	f.close()
	print(config)
	print(progression)

func save_game():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://Herbi.save", File.WRITE, "Herbi")
	f.store_var(config)
	f.store_var(progression)
	f.close()
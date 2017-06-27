extends Node

const default_config = {
	music = true,
	sound = true,
	fullscreen = false
}

const events = {
	first_finish = false,
	first_contact = false,
	next_level_error = false
}

var temporary_events = {
	debug_next_level = false
}

var config = {}
var progression = {}

func _ready():
	load_game()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		get_tree().quit()

func load_game():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://save/saved_game.save", File.READ, "Herbi")
	
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
	
	f.close()
	print(config)
	print(progression)

func save_game():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://save/saved_game.save", File.WRITE, "Herbi")
	f.store_var(config)
	f.store_var(progression)
	f.close()
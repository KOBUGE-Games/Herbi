extends Node

const default_config = {
	music = true,
	sound = true,
	fullscreen = false
}

const starting_state = {
	first_finish = false
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
	var err = f.open_encrypted_with_pass("res://save/saved_game.bin", File.READ, "Herbi")
	
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
		progression = starting_state
	else:
		for option in starting_state:
			if !progression.has(option):
				progression[option] = starting_state[option]
	
	f.close()
	print(config)
	print(progression)

func save_game():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://save/saved_game.bin", File.WRITE, "Herbi")
	f.store_var(config)
	f.store_var(progression)
	f.close()
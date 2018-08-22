extends CanvasLayer

onready var world = get_node("/root/world")
onready var animation_player = get_node("AnimationPlayer")
onready var music_button = get_node("Control/Sprite/music")
onready var sound_button = get_node("Control/Sprite/sound")
var shown = false

onready var button_select = world.get_node("button_select/Node2D")

func _ready():
	for button in get_node("Control/Sprite").get_children():
		button.connect("pressed", global, "play_sound", ["click"])
	music_button.set_pressed(save_manager.config.music)
	sound_button.set_pressed(save_manager.config.sound)

	music_button.connect("pressed", self, "set_music")
	sound_button.connect("pressed", self, "set_sound")
	get_node("Control/Sprite/restart").connect("pressed", self, "restart")
	get_node("Control/Sprite/exit").connect("pressed", self, "quit")

	animation_player.connect("animation_started", button_select, "set_active", [false])
	set_process_input(true)

func show():
	shown = !shown
	events_texts.event.paused = shown
	world.can_move = !shown
	if shown:
		button_select.buttons_dir = get_node("Control/Sprite")
		animation_player.connect("finished", button_select, "set_active", [null, shown], 4)
		animation_player.play("show")
	else:
		events_texts.event.paused = false
		animation_player.play("hide")
		if events_texts.writing:
			animation_player.connect("finished", events_texts, "check_buttons")

func set_sound():
	save_manager.config.sound = !save_manager.config.sound

func set_music():
	save_manager.config.music = !save_manager.config.music
	events_texts.check_music()

func restart():
	disable()
	global.lives = world.start_lives
	global.apples = world.start_apples
	global.score = world.start_score
	world.stop()

func quit():
	disable()
	world.quit = true
	world.stop()

func disable(param=true):
	if shown:
		show()

func _input(event):
	if event.is_action_pressed("ui_cancel") and not animation_player.is_playing():
		show()
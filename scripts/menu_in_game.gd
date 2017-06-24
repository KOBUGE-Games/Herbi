extends CanvasLayer

onready var world = get_node("/root/world")
onready var animation_player = get_node("AnimationPlayer")
onready var music_button = get_node("Control/Sprite/music")
onready var sound_button = get_node("Control/Sprite/sound")
var shown = false

func _ready():
	for button in get_node("Control/Sprite").get_children():
		button.connect("pressed", global, "play_sound", ["click"])
	get_node("Control/Button").connect("pressed", global, "play_sound", ["click"])
	music_button.set_pressed(global.is_music)
	sound_button.set_pressed(global.is_sound)
	set_process_input(true)

func show():
	if shown:
		world.can_move = true
		animation_player.play("hide")
	else:
		world.can_move = false
		animation_player.play("show")
	shown = !shown

func set_sound():
	global.is_sound = !global.is_sound

func set_music():
	global.is_music = !global.is_music
	world.check_music()

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
	for button in get_node("Control/Sprite").get_children():
		button.set_disabled(param)

func _input(event):
	if world.can_quit:
		if event.is_action_pressed("ui_cancel"):
			show()
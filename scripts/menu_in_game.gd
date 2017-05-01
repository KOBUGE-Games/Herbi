extends CanvasLayer

onready var world = get_node("../../")
onready var animation_player = get_node("AnimationPlayer")
onready var music = get_node("Control/Sprite/music")
onready var sound = get_node("Control/Sprite/sound")
var shown = false

func _ready():
	music.set_pressed(global.music)
	sound.set_pressed(global.sound)
	set_process_input(true)

func show():
	if shown:
		animation_player.play("hide")
	else:
		animation_player.play("show")
	shown = !shown

func set_sound():
	global.sound = !global.sound

func set_music():
	global.music = !global.music
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
		elif event.is_action_pressed("restart"):
			restart()
	if not event.is_echo() && event.is_pressed():
		if event.type == InputEvent.KEY:
			if event.scancode == KEY_F3:
				set_music()
				music.set_pressed(!music.is_pressed())
			elif event.scancode == KEY_F4:
				set_sound()
				sound.set_pressed(!sound.is_pressed())
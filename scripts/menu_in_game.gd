extends CanvasLayer

onready var world = get_node("../../")
onready var animation_player = get_node("AnimationPlayer")
var shown = false

func _ready():
	get_node("Control/Sprite/music").set_pressed(global.music)
	get_node("Control/Sprite/sound").set_pressed(global.sound)

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
	world.get_node("player").dead = true
	world.stop()

func quit():
	disable()
	world.quit = true
	world.stop()

func disable():
	for button in get_node("Control/Sprite").get_children():
		button.set_disabled(true)
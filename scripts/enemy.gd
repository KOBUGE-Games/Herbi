extends KinematicBody2D

var walk_right = true
export var speed = 1.00

onready var player = get_node("/root/world/player")
onready var sprites = get_node("sprites")

func _ready():
	add_to_group("enemies")
	if has_node("check_down"):
		get_node("check_down").add_exception(self)
	else:
		add_to_group("flying")
	
	walk_right = bool(randi()% 2)
	set_fixed_process(true)

func _fixed_process(delta):
	#toggle direction
	if has_node("check_down"):
		if not get_node("check_down").is_colliding():
			sprites.set_flip_h(walk_right)
			walk_right = !walk_right
	
	#walk anim
	if not is_in_group("flying"):
		if (int(get_pos().x)*3)/2 % 50 < 25:
			sprites.set_frame(0)
		else:
			sprites.set_frame(1)

	#do movement
	if walk_right:
		move(Vector2(speed,0))
	else:
		move(Vector2(-speed,0))
	
	if get_pos().x <= 8 and !walk_right:
		sprites.set_flip_h(walk_right)
		walk_right = true
	elif get_pos().x >= global.margin_right and walk_right:
		sprites.set_flip_h(walk_right)
		walk_right = false
	elif is_colliding():
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		if not body.dead and not body.shape.is_trigger():
			var add = 18
			if is_in_group("flying"):
				add = 16
			if body.get_pos().y+add > get_pos().y:
				get_node("/root/world").remove_life()
			kill_monster()

func kill_monster():
	global.enemies_killed += 1
	global.play_sound("killmonster")
	queue_free()
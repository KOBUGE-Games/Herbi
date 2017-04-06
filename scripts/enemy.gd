extends KinematicBody2D

var init_posy = 0.0
var walk_right = true
var checked = false
export var speed = 1.0

onready var player = get_node("/root/world/player")
onready var sprites = get_node("sprites")

onready var check_down = get_node("check_down")

func _ready():
	add_to_group("enemies")
	check_down.add_exception(self)
	set_fixed_process(true)

func _fixed_process(delta):
	#toggle direction
	if !check_down.is_colliding():
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right
		
	#walk anim
	if (int(get_pos().x)*3)/2 % 50 < 25:
		sprites.set_frame(0)
	else:
		sprites.set_frame(1)

	#do movement
	if walk_right:
		move(Vector2(speed,0))
	else:
		move(Vector2(-speed,0))
		
	if is_colliding():
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		if body.can_move:
			if player.get_pos().y+17 > get_pos().y:
				get_node("/root/world").remove_life()
			kill_monster()

func kill_monster():
	global.enemies_killed += 1
	get_node("/root/world/SamplePlayer").play("killmonster")
	queue_free()
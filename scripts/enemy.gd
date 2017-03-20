extends KinematicBody2D

var init_posy
var walk_right = true
export var speed = 1.0

onready var player = get_node("/root/world/player")
onready var sprites = get_node("sprites")

func _ready():
	add_to_group("enemies")
	get_node("check_down").add_exception(self)
	if get_name().begins_with("bear"):
		init_posy = -0.07
	else:
		init_posy = 0.5
	set_pos(Vector2(get_pos().x,get_pos().y+init_posy))
	set_fixed_process(true)

func _fixed_process(delta):
	#toggle direction
	if !get_node("check_down").is_colliding():
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right
		
	#walk anim
	if int(get_pos().x) % 50 < 25:
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
			get_node("/root/world/SamplePlayer").play("killmonster")
			if player.get_pos().y+16 > get_pos().y:
				get_node("/root/world").remove_life()
			queue_free()
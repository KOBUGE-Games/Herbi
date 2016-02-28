extends KinematicBody2D

var walk_right = true
var speed = 2
var run = 4
var movement = speed
onready var player = get_node("/root/world/player")

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)
	get_node("check_down").add_exception(self)
	get_node("check_right").add_exception(self)
	get_node("check_left").add_exception(self)
	set_pos(Vector2(get_pos().x,get_pos().y-4))
	
func _fixed_process(delta):
	#toggle direction
	if !get_node("check_down").is_colliding():
		get_node("sprites").set_flip_h(walk_right)
		walk_right = !walk_right
		
	#walk anim
	if int(get_pos().x) % 50 < 25:
		get_node("sprites").set_frame(0)
	else:
		get_node("sprites").set_frame(1)

	#do movement
	if walk_right:
		move(Vector2(movement,0))
	else:
		move(Vector2(-movement,0))

	if get_node("check_right").is_colliding() and get_node("check_down").is_colliding():
		if get_node("check_right").get_collider().get_name() == "player":
			walk_right = true
			movement = run
			get_node("sprites").set_flip_h(!walk_right)
		else:
			movement = speed

	elif get_node("check_left").is_colliding() and get_node("check_down").is_colliding():
		if get_node("check_left").get_collider().get_name() == "player":
			walk_right = false
			movement = run
			get_node("sprites").set_flip_h(!walk_right)
		else:
			movement = speed
	else:
		movement = speed
		if is_colliding():
			get_node("sprites").set_flip_h(walk_right)
			walk_right = !walk_right

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		if player.get_pos().y+32 > get_pos().y:
			get_node("/root/world").remove_life()
		queue_free()

extends KinematicBody2D

const speed = 1
const run = 2.25

var movement = speed
var walk_right = true
var can_attack = true

onready var player = get_node("/root/world/player")
onready var sprites = get_node("sprites")

onready var check_down = get_node("check_down")
onready var check_right = get_node("check_right")
onready var check_left = get_node("check_left")

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)
	check_down.add_exception(self)
	check_right.add_exception(self)
	check_left.add_exception(self)

func _fixed_process(delta):
	#toggle direction
	if !check_down.is_colliding():
		can_attack = false
		get_node("Timer").start()
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right
	
	#walk anim
	if (int(get_pos().x)*3)/2 % 50 < 25:
		sprites.set_frame(0)
	else:
		sprites.set_frame(1)
	
	#do movement
	if walk_right:
		move(Vector2(movement,0))
	else:
		move(Vector2(-movement,0))
	
	if check_right.is_colliding() and check_down.is_colliding():
		var body = check_right.get_collider()
		collision_check()
		if body.get_name() == "player" and can_attack:
			if body.can_move:
				if has_path_to_target(body.get_pos()):
					walk_right = true
					movement = run
					sprites.set_flip_h(!walk_right)
	elif check_left.is_colliding() and check_down.is_colliding():
		var body = check_left.get_collider()
		collision_check()
		if body.get_name() == "player" and can_attack:
			if body.can_move:
				if has_path_to_target(body.get_pos()):
					walk_right = false
					movement = run
					sprites.set_flip_h(!walk_right)
	else:
		movement = speed
		collision_check()

func has_path_to_target(target, distance = 30):
	var current = get_pos()
	target.y = current.y # Make only horizontal checking
	
	var layer_mask = check_down.get_layer_mask()
	var type_mask = check_down.get_type_mask()
	
	var direct_state = get_world_2d().get_direct_space_state()
	var count = current.distance_to(target) / 16
	for i in range(0, count):
		var check = current.linear_interpolate(target, i/count)
		var result = direct_state.intersect_ray(check, check + Vector2(0, distance), [self], layer_mask, type_mask)
		if !result.has("position"):
			return false # Can't pass if there is nothing to stand on
	return true

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		if body.can_move:
			if player.get_pos().y+18 > get_pos().y:
				get_node("/root/world").remove_life()
			kill_monster()

func kill_monster():
	global.enemies_killed += 1
	global.play_sound("killmonster")
	queue_free()

func collision_check():
	if is_colliding():
		can_attack = false
		get_node("Timer").start()
		sprites.set_flip_h(walk_right)
		walk_right = !walk_right

func _on_Timer_timeout():
	can_attack = true
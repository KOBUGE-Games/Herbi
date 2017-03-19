extends KinematicBody2D

var walk_right = true
var speed = 1
var run = 2
var movement = speed
onready var player = get_node("/root/world/player")
var player_vy = 0

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)
	get_node("check_down").add_exception(self)
	get_node("check_right").add_exception(self)
	get_node("check_left").add_exception(self)
	set_pos(Vector2(get_pos().x,get_pos().y))

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
		var player = get_node("check_right").get_collider()
		if player.get_name() == "player":
			if player.can_move:
				if has_path_to_target(player.get_pos()):
					walk_right = true
					movement = run
					get_node("sprites").set_flip_h(!walk_right)
		else:
			movement = speed
	
	elif get_node("check_left").is_colliding() and get_node("check_down").is_colliding():
		var player = get_node("check_left").get_collider()
		if player.get_name() == "player":
			if player.can_move:
				if has_path_to_target(player.get_pos()):
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

func has_path_to_target(target, distance = 30):
	var current = get_pos()
	target.y = current.y # Make only horizontal checking
	
	var layer_mask = get_node("check_down").get_layer_mask()
	var type_mask = get_node("check_down").get_type_mask()
	
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
			get_node("/root/world/SamplePlayer").play("killmonster")
			player_vy = player.velocity.y
			if player.get_pos().y+16 > get_pos().y and player_vy <= 0:
				get_node("/root/world").remove_life()
			queue_free()
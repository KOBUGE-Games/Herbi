extends KinematicBody2D

var walk_right = true

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)
	get_node("check_down").add_exception(self)
	
func _fixed_process(delta):
	if !get_node("check_down").is_colliding():
		get_node("sprites").set_flip_h(walk_right)
		walk_right = !walk_right
		
	if int(get_pos().x) % 50 < 25:
		get_node("sprites").set_frame(0)
	else:
		get_node("sprites").set_frame(1)

	if walk_right:
		move(Vector2(2,0))
	else:
		move(Vector2(-2,0))
		
	if is_colliding():
		if get_collider().get_name() == "player":
			queue_free()
			get_node("/root/world").update_lives(-1)
		get_node("sprites").set_flip_h(walk_right)
		walk_right = !walk_right
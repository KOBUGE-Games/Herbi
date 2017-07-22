extends Node2D

export var frames = 1
export var random_amount = 0
export var random_tiles = 0
var random = 0

var except_left = false
var except_right = false

func _ready():
	random = randi() % frames
	
	if random_amount != 0:
		var add = (randi() % random_amount)
		if add > (random_amount-2):
			random += (randi()% random_tiles) + 1
	
	get_node("AnimatedSprite").set_frame(random)

###################### ROCK PLATFORM SPECIFIC ######################

func detect(body):
	if body.get_name() == "player":
		play_anim()

func play_anim():
	if not get_node("AnimationPlayer").is_playing():
		get_node("AnimationPlayer").play("default")
		if get_node("AnimatedSprite/rock_lift/rays/left").get_collider() != null and not except_left:
			detect_other(get_node("AnimatedSprite/rock_lift/rays/left"))
		if get_node("AnimatedSprite/rock_lift/rays/right").get_collider() != null and not except_right:
			detect_other(get_node("AnimatedSprite/rock_lift/rays/right"))

### Except avoids the node on the side stated to check again for the collider
### This avoids unfinite checkings

func detect_other(ray):
	var collider = ray.get_collider()
	if collider != null:
		if collider.get_name() == "rock_lift":
			if not collider.get_node("../../AnimationPlayer").is_playing():
				collider.get_node("../../").play_anim()
				if ray.get_name() == "left":
					collider.get_node("../../").except_right = true
				elif ray.get_name() == "right":
					collider.get_node("../../").except_left = true

func reset_except():
	except_left = false
	except_right = false
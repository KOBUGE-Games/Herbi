extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("AnimatedSprite").set_frame(randi() % 3)
	get_node("AnimatedSprite/AnimationPlayer").set_speed(rand_range(0.5,1))
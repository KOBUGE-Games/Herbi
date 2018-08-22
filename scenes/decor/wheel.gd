extends Sprite

var speed = 0
var size = 0.75 + 0.25*(randi() % 5)

func _ready():
	while speed == 0:
		speed = (randi() % 5 - 2)/2
	get_node("AnimationPlayer").set_speed(speed)
	set_scale(Vector2(size, size))
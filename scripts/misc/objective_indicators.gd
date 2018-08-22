extends Camera2D

var shown = false
onready var timer = get_node("Timer")
onready var sprite = get_node("CanvasLayer/Sprite")
onready var world = get_node("/root/world")

#func _ready():
#	timer.connect("timeout", self, "update_positionning")
#	timer.start()
#
######## UNWORKING AS FUCK ########
#

func update_positionning(shown=true):
	if shown:
		for node in world.get_node("level/front").get_children():
			if node.get_groups().has("objectives"):
				var distance = node.get_pos() - get_pos()
				var angle = Vector2(1,0).angle_to(distance)
				print(angle)
				if abs(distance.x) > 200 or abs(distance.y) > 180:
					if abs(cos(angle)) > abs(sin(angle)):
						var indicator = sprite.duplicate()
						indicator.set_pos(Vector2(160+sign(cos(angle))*150, 120+sin(-angle)*100))
						indicator.set_modulate(Color(1,1,1,(1*(distance.x/200))))
						indicator.show()
						get_node("CanvasLayer").add_child(indicator)
					elif abs(sin(angle)) > abs(cos(angle)):
						var indicator = sprite.duplicate()
						indicator.set_pos(Vector2(160+cos(angle)*150, 120+sign(sin(-angle))*100))
						indicator.set_modulate(Color(1,1,1,(1*(distance.y/180))))
						indicator.show()
						get_node("CanvasLayer").add_child(indicator)
	else:
		for node in get_node("CanvasLayer").get_children():
			if node.get_name() != "Sprite":
				node.queue_free()
	
	timer.start()
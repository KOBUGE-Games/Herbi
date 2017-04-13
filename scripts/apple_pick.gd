extends Sprite

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		global.apples_picked += 1
		get_node("/root/world").add_apple()
		queue_free()
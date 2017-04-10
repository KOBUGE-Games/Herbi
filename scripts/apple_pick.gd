extends Area2D

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		global.apples_picked += 1
		get_parent().queue_free()
		get_node("/root/world").add_apple()
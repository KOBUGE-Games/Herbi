extends StaticBody2D

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		get_node("/root/world").remove_life()
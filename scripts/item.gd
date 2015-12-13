extends Area2D

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		get_parent().queue_free()

extends Area2D

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		get_node("/root/world/SamplePlayer").play("pop")
		get_parent().queue_free()
		get_node("/root/world").add_apple()
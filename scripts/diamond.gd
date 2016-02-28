extends Node2D

func _ready():
	get_node("/root/world").add_diamond()

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		queue_free()
		get_node("/root/world").collect_diamond()
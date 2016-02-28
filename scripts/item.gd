extends Area2D

export var score = 1

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		get_parent().queue_free()
		get_node("/root/world").update_score(score)

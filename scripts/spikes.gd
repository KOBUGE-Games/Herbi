extends StaticBody2D

onready var player = get_node("/root/world/player")

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		get_node("/root/world").update_lives(-1)

extends RigidBody2D

onready var player_dir = get_node("/root/world/player").dir_right

func _ready():
	add_to_group("apple")
	if player_dir:
		set_linear_velocity(Vector2(500,0))
	else:
		set_linear_velocity(Vector2(-500,0))

func _on_self_destroy_timeout():
	queue_free()

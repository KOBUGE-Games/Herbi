extends CanvasLayer

func _ready():
	get_node("AnimationPlayer").get_animation("enter").track_set_key_value(0, 6, str("Level ", str(global.level)))
	get_node("AnimationPlayer").play("enter")
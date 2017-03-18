extends CanvasLayer

func _ready():
	get_node("Label").set_text(str("level ", str(global.level)))

func _on_Timer_timeout():
	queue_free()
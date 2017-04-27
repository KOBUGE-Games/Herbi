extends Node2D

const p_points = preload("res://scenes/items/points_indicator.tscn")
export var score = 5
onready var timer = get_node("Timer")

func _ready():
	get_node("Sprite").set_frame(randi() % 3)
	timer.set_wait_time(rand_range(0,0.5))
	timer.start()
	timer.connect("timeout", get_node("Idle"), "play", ["idle"])

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		var points = p_points.instance()
		points.get_node("Label").set_text(str("+", str(score)))
		points.set_pos(get_pos()+Vector2((randi()%5) -2,(randi()%5) -2))
		get_parent().add_child(points)
		global.final_score += score
		get_node("/root/world").update_score(score)
		queue_free()
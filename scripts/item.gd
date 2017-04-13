extends Node2D

export var score = 5
onready var timer = get_node("Timer")

func _ready():
	timer.set_wait_time(rand_range(0,0.5))
	timer.start()
	timer.connect("timeout", get_node("Idle"), "play", ["idle"])

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		global.final_score += score
		get_node("/root/world").update_score(score)
		queue_free()
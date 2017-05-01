extends Node2D

const p_pillar = preload("res://scenes/misc/diamond_pillar.tscn")
var pillar

func _ready():
	pillar = p_pillar.instance()
	pillar.set_pos(get_pos()+ Vector2(0, 8))
	get_parent().call_deferred("add_child", pillar)
	get_parent().call_deferred("move_child", pillar, 0)
	get_node("/root/world").add_diamond()

func _on_Area2D_body_enter( body ):
	if body.get_name() == "player":
		for node in get_parent().get_children():
			if node.has_node("pillar_anim"):
				if abs(node.get_pos().x - get_pos().x) < 16 and abs(node.get_pos().y - get_pos().y) < 16:
					node.get_node("pillar_anim").play("checkpoint")
				else:
					node.get_node("pillar_anim").stop()
					node.set_modulate(Color(1,1,1))
		get_node("/root/world").last_checkpoint = get_pos()
		get_node("/root/world").collect_diamond()
		queue_free()
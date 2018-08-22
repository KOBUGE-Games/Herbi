extends Node2D

const button_class = preload("res://scripts/button.gd")

var buttons = []
var button_id = 0
var active = false
var buttons_dir

func _ready():
	set_process_input(true)

func set_active(anim=null, boolean=true):
	active = boolean
	update_buttons()

func _input(event):
	if get_parent().get_name() == "world":
		if event.is_action_pressed("ui_cancel"):
			get_node("../hud/menu").show()
	
	if active:
		if event.is_action_pressed("move_right") or event.is_action_pressed("down"):
			button_id += 1
			set_button(button_id)
			global.play_sound("tic")
		elif event.is_action_pressed("move_left") or event.is_action_pressed("up"):
			button_id -= 1
			set_button(button_id)
			global.play_sound("tic")
		if event.is_action_pressed("jump"):
			buttons[button_id].set_pressed(!buttons[button_id].is_pressed())
			buttons[button_id].emit_signal("pressed")

func update_buttons():
	buttons.clear()
	for button in buttons_dir.get_children():
		if button.is_visible() and (button extends BaseButton or button extends button_class):
			buttons.append(button)
	set_button(0)

func set_button(number):
	if button_id >= buttons.size():
		button_id = 0
	elif button_id <= -1:
		button_id = buttons.size()-1
	update()

func _draw():
	if active and buttons != []:
		var object = buttons[button_id]
		var color = Color(1,1,1)

		var x_pos = object.get_global_pos().x
		var y_pos = object.get_global_pos().y
		
		var x_size
		var y_size

		if object extends button_class:
			x_size = object.get_scale().x * object.get_parent().get_scale().x * 32
			y_size = object.get_scale().y * object.get_parent().get_scale().y * 8
		else:
			x_size = object.get_size().x * object.get_scale().x * object.get_parent().get_scale().x
			y_size = object.get_size().y * object.get_scale().y * object.get_parent().get_scale().y

		draw_rect(Rect2(Vector2(x_pos-3, y_pos-3), Vector2(x_size+3, 3)), color)
		draw_rect(Rect2(Vector2(x_pos-3, y_pos+y_size), Vector2(x_size+3, 3)), color)

		draw_rect(Rect2(Vector2(x_pos-3, y_pos-3), Vector2(3, y_size+6)), color)
		draw_rect(Rect2(Vector2(x_pos+x_size, y_pos-3), Vector2(3, y_size+6)), color)
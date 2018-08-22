extends Node

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed() and global.debug and global.can_quit and not get_node("/root/debug_menu").shown:
		if event.scancode == KEY_T:
			global.level = 0
			global.level_name = "level_"
			get_tree().change_scene("res://scenes/misc/keys_info.tscn")
		
		if get_parent().get_name() == "world":
			var world = get_parent()
			if event.scancode == KEY_W:
				world.add_life()
			elif event.scancode == KEY_A and not world.next_level:
				global.level -= 1
				world.stop(false)
			elif event.scancode == KEY_S:
				world.remove_life()
			elif event.scancode == KEY_D and not world.next_level:
				if global.level <= global.total_levels:
					world.stop(true)
					save_manager.temporary_events.debug_next_level = true
			elif event.scancode == KEY_Q:
				world.add_apple()
			elif event.scancode == KEY_E:
				world.collect_diamond()
			elif event.scancode == KEY_H:
				world.hidden_bg = !world.hidden_bg
				world.hide_back(world.hidden_bg)
			elif event.scancode == KEY_U:
				get_node("../player/CollisionShape2D").set_trigger(!get_node("../player/CollisionShape2D").is_trigger())
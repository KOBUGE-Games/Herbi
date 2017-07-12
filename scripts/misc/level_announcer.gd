extends CanvasLayer

var i = 0
var text = (global.level_name+str(global.level))

onready var timer = get_node("Timer")
onready var label = get_node("Label")

func write_next():
	i += 1
	if i >= text.length():
		timer.disconnect("timeout", self, "write_next")
		timer.set_wait_time(2)
		timer.connect("timeout", self, "remove_text")
	label.set_text(text.substr(0, i))
	timer.start()

func remove_text():
	i -= 1
	timer.set_wait_time(0.15)
	if i <= 0:
		queue_free()
	label.set_text(text.substr(0, i))
	timer.start()
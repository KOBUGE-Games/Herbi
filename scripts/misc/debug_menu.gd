extends CanvasLayer

var shown = false
var checkboxes = []

func _ready():
	show(shown)
	set_process_input(true)
	### Creation of the events menu
	for i in range(save_manager.progression.size()):
		var container = HBoxContainer.new()
		var label = Label.new()
		var checkbox = CheckBox.new()
		
		label.set_text(save_manager.progression.keys()[i]) #Get the key i in the dict
		checkbox.set_pressed(save_manager.progression.values()[i]) #Get the corresponding value i and put as is_pressed in the checkbox
		checkboxes.append(checkbox) #Append the checkbox object to the array for save()'s manipulations
		
		get_node("options/VBoxContainer").add_child(container)
		container.add_child(label)
		container.add_child(checkbox)
		
		checkbox.connect("pressed", self, "save")

func save():
	# Create a json string, following json's dicts synthax
	var text = ''
	for i in range(save_manager.progression.size()):
		text += str('"'+save_manager.progression.keys()[i]+'":'+str(checkboxes[i].is_pressed()).to_lower()) #bools are lowercase in json
		if i < save_manager.progression.size():
			text += ', '
	
	save_manager.progression.parse_json(str("{"+text+"}"))# add the missing synthax elements
	save_manager.save_game()
	print(save_manager.progression)

func _input(event):
	if event.is_action_pressed("debug"):
		shown = !shown
		show(shown)

func show(shown):
	get_node("level_name").set_editable(shown)
	get_node("level").set_editable(shown)
	get_node("Button").set_disabled(!shown)
	for node in get_children():
		node.set("visibility/visible", shown)

func load_level():
	global.level_name = get_node("level_name").get_text()
	global.level = get_node("level").get_text().to_int()
	get_tree().change_scene("res://scenes/main.tscn")
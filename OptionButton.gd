extends MenuButton

@onready var optionPopup = get_popup()

# Called when the node enters the scene tree for the first time.
func _ready():
	#optionPopup.add_item("Exit", 0)
	optionPopup.connect("index_pressed", _on_item_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_item_pressed(ID):
	var selected = optionPopup.get_item_text(ID)
	print(selected, " pressed")
	match(selected.to_lower()):
		"exit":
			get_tree().quit()
			pass
		"mute":
			var masterbus = AudioServer.get_bus_index("Master")
			AudioServer.set_bus_mute(masterbus, not AudioServer.is_bus_mute(masterbus))
			pass
		"logout":
			pass
	pass

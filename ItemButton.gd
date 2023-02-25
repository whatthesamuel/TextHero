extends MenuButton

@onready var itemPopup = get_popup()

# Called when the node enters the scene tree for the first time.
func _ready():
	itemPopup.add_item("potion of strength")
	itemPopup.add_item("potion of strength")
	itemPopup.connect("index_pressed", _on_item_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_pressed(ID):
	var selected = itemPopup.get_item_text(ID)
	print(selected, " pressed")
	match(selected.to_lower()):
		"potion of strength":
			var amount = randi_range(3, 10)
			$"../../../Player".heal(amount)
			
	pass

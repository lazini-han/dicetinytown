extends Label
var unselected = 4

onready var game = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	game.connect("dice_selected_changed", self, "_update_selected")
	
func _update_selected(new_dice_selected):
	if new_dice_selected == unselected:
		text = ""
	else:
		text = str(get_parent().dice_face[new_dice_selected])
	

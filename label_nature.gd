extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("update_nature_label", self, "_on_update_nature_label")

func _on_update_nature_label(dice_value):
	text = str(dice_value)
				
		

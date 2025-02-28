extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("update_building_label", self, "_on_update_building_label")

func _on_update_building_label(dice_value):
	text = str(dice_value)
				
		

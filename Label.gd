extends Label
export var this_label_number: int # 각 Sprite 마다 다른 값 설정

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("change_label", self, "_on_change_label")

func _on_change_label(dice_in_box, dice_value):
	print("_on_change_label:",dice_in_box, dice_value)
	for i in range(3):
		if i == this_label_number:
			if dice_in_box[i] == null:
				text = ""
			else:
				text = str(dice_value[dice_in_box[i]])
				
		

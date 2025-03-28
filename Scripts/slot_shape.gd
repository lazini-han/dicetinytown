extends Slot


func _ready():
	slot_type = "Shape"


func _on_SlotShape_area_entered(area):
	on_area_entered(area)


func _on_SlotShape_area_exited(area):
	on_area_exited(area)


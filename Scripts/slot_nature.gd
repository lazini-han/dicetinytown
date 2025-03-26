extends Slot

func _ready():
	slot_type = "Nature"


func _on_SlotNature_area_entered(area):
	on_area_entered(area)


func _on_SlotNature_area_exited(area):
	on_area_exited(area)

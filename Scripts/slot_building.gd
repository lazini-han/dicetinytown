extends Slot

func _ready():
	slot_type = "Building"


func _on_SlotBuilding_area_entered(area):
	on_area_entered(area)


func _on_SlotBuilding_area_exited(area):
	on_area_exited(area)

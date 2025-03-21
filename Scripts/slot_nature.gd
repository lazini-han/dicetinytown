extends Area2D

const OCCUPIED = true
const UNOCCUPIED = false

var current_dice: Area2D
var slot_value: int

func _on_SlotNature_area_entered(area):
	current_dice = area
	slot_value = current_dice.dice_value
	print("SlotNature is occupied by %d" % slot_value)


func _on_SlotNature_area_exited(area):
	if area == current_dice:
		current_dice = null
		print("SlotNature is unoccupied")

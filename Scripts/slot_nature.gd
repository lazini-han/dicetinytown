extends Area2D

const OCCUPIED = true
const UNOCCUPIED = false

var current_dice: Area2D
var dice_index: int
var slot_value: int

func _on_SlotNature_area_entered(area):
	current_dice = area
	dice_index = current_dice.dice_index
	slot_value = current_dice.dice_value
	Eventbus.emit_signal("state_changed", "DICE_OCCUPIED")
	print("SlotNature is occupied by %d" % slot_value)


func _on_SlotNature_area_exited(area):
	if area == current_dice:
		current_dice = null
		Eventbus.emit_signal("state_changed", "DICE_FREE")
		print("SlotNature is unoccupied")

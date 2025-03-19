extends Area2D

const OCCUPIED = true
const UNOCCUPIED = false

var current_dice: Area2D
var dice_index: int
var slot_value = 0 # black

func _on_SlotShape_area_entered(area):
	current_dice = area
	dice_index = current_dice.dice_index
	slot_value = current_dice.dice_value
	Eventbus.emit_signal("shape_selected", slot_value)
	print("SlotShape is occupied by %d" % slot_value)


func _on_SlotShape_area_exited(area):
	if area == current_dice:
		current_dice = null
		slot_value = 0
		Eventbus.emit_signal("shape_selected", slot_value)
		print("SlotShape is unoccupied")


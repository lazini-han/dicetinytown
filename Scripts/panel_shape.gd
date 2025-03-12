extends Area2D

const OCCUPIED = true
const UNOCCUPIED = false

var current_dice: Area2D
var dice_index: int
var slot_value: int

func _on_SlotShape_area_entered(area):
	current_dice = area
	dice_index = current_dice.dice_index
	slot_value = current_dice.dice_value
	print("SlotShape is occupied by %d" % slot_value)
	Eventbus.emit_signal("slot_shape_occupied", current_dice, OCCUPIED)

func _on_SlotShape_area_exited(area):
	if area == current_dice:
		current_dice = null
		print("SlotShape is unoccupied")
		Eventbus.emit_signal("slot_shape_occupied", current_dice, UNOCCUPIED)


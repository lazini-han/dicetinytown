# Slot Class
extends Area2D
class_name Slot

var current_dice: Area2D
var slot_value: int
var slot_type: String

signal slot_changed(slot_type, value)

func _ready():
	slot_value = 0
	
func on_area_entered(area):
	current_dice = area
	slot_value = current_dice.dice_value
	emit_signal("slot_changed", slot_type, slot_value)
	print("%s is occupied by %d" % [slot_type, slot_value])

func on_area_exited(area):
	if area == current_dice:
		current_dice = null
		slot_value = 0
		emit_signal("slot_changed", slot_type, slot_value)
		print("%s is unoccupied" % slot_type)

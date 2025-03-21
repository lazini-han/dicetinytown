class_name DiceToSlotCommand
extends "res://Classes/command.gd" 
#extends Command

var dice
var slot_index
var dice_manager


func _init(dice_node, target_slot_index, DiceManager):
	dice = dice_node
	slot_index = target_slot_index
	dice_manager = DiceManager
	

func execute():
	dice_manager.dice_move_to_slot(dice, slot_index)
	print("EXECUTE: DiceToSlot COMMAND")


func undo():
	dice_manager.dice_move_back(dice, slot_index)
	print("UNDO: DiceToSlot COMMAND")

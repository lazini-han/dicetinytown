class_name DiceMoveToSlotCommand
extends "res://Scripts/Classes/command.gd" 
#extends Command

var init_pos: Vector2
var slot: Area2D
var dice: Area2D


func _init(dice_node, target_slot_node):
	init_pos = dice_node.global_position
	slot = target_slot_node
	dice = dice_node


func execute():
	dice.global_position = slot.global_position
	

func undo():
	dice.global_position = init_pos

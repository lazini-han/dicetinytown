# Dice Move
class_name DiceMoveCommand
extends "res://Scripts/Commands/command.gd" 
#extends Command

var init: Vector2
var final: Vector2
var dice: Area2D


func _init(dice_node, init_pos, final_pos):
	init = init_pos
	final = final_pos
	dice = dice_node


func execute():
	dice.global_position = final
	Eventbus.emit_signal("target_slot_update")
	

func undo():
	dice.global_position = init
	Eventbus.emit_signal("target_slot_update")

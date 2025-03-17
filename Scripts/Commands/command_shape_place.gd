class_name ShapePlaceCommand
extends "res://Scripts/Commands/command.gd" 
#extends Command

var now_board: Array
var blocks: Array

func _init(input_board, block_tiles):
	now_board = input_board
	blocks = block_tiles


func execute():
	print("EXECUTE command shape place")
	
	for b_tile in blocks:
		now_board[b_tile.y][b_tile.x].set_state("filled")
		print(b_tile)
#Eventbus.emit_signal("target_slot_update")
	

func undo():
	print("UNDO command shape place")
	for b_tile in blocks:
		now_board[b_tile.y][b_tile.x].set_state("empty")
	#Eventbus.emit_signal("target_slot_update")


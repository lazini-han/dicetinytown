extends Node2D

var stage_data = {
	"total_round" : 1,
	"dice_value" : [1,2,3],
	"dice_list" : [],
	"dice_position_list" : [],
	"slot_list" : [],
	"board_size" : 3,
	"board" : [ 
		[0,0,0],
		[0,0,0],
		[0,0,0],
	]
}

var command_stack = []


func _ready():
	stage_data["dice_list"] = [
		$Dice1, 
		$Dice2,
		$Dice3,
	]
	stage_data["dice_position_list"] = [
		$Position1,
		$Position2,
		$Position3,
	]
	stage_data["slot_list"] =[
		$SlotShape,
		$SlotBuilding,
		$SlotNature,
	]
		
	var dice_manager = load(GameManager.classes["DiceManager"]).new()
	add_child(dice_manager)
	
	var dice_list = stage_data["dice_list"]
	var dice_position_list = stage_data["dice_position_list"]
	var slot_list = stage_data["slot_list"]
	dice_manager.initialize(dice_list, dice_position_list, slot_list)
	
	
	# 미리 설정된 주사위 값들 넣기
	dice_manager.set_random_numbers(stage_data["dice_value"]) 
	



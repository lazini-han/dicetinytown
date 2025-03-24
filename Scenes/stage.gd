extends Node2D

var stage_data = {
	"stage_num" : 1,
	"total_round" : 1,
	"dice_value" : [1,2,3],
	"dice_list" : [],
	"dice_position_list" : [],
	"slot_list" : [],
	"board" : [ 
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
	]
}


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
	var tile_manager = load(GameManager.classes["TileManager"]).new()
	dice_manager.set_name("DiceManager")
	tile_manager.set_name("TileManager")
	add_child(dice_manager)
	add_child(tile_manager)
	$InputManager.set_dice_manager(dice_manager)
	$InputManager.set_tile_manager(tile_manager)
	
	var dice_list = stage_data["dice_list"]
	var dice_position_list = stage_data["dice_position_list"]
	var slot_list = stage_data["slot_list"]
	dice_manager.initialize(dice_list, dice_position_list, slot_list)
	dice_manager.set_random_numbers(stage_data["dice_value"]) # 미리 설정된 주사위 값들 넣기
	
	var board = stage_data["board"]
	tile_manager.initialize(board)
	
	
	

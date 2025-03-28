extends Node2D

onready var dice_manager = load(GameManager.classes["DiceManager"]).new()
onready var tile_manager = load(GameManager.classes["TileManager"]).new()
onready var input_manager = $InputManager

onready var stage_data = {
	"stage_num" : 1,
	"total_round" : 1,
	"dice_value" : [1,2,3],
	"dice_list" : [
		$Dice1, 
		$Dice2,
		$Dice3,
	],
	"dice_position_list" : [
		$Position1,
		$Position2,
		$Position3,
	],
	"slot_list" : [
		$SlotShape,
		$SlotBuilding,
		$SlotNature,
	],
	"board" : [ 
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
	]
}


func _ready():
	dice_manager.set_name("DiceManager")
	tile_manager.set_name("TileManager")
	add_child(dice_manager)
	add_child(tile_manager)
	input_manager.set_dice_manager(dice_manager)
	input_manager.set_tile_manager(tile_manager)
	
	dice_manager.initialize(stage_data["dice_list"],  stage_data["dice_position_list"], stage_data["slot_list"])
	dice_manager.set_random_numbers(stage_data["dice_value"]) # 미리 설정된 주사위 값들 넣기
	
	tile_manager.initialize(stage_data["board"], input_manager)

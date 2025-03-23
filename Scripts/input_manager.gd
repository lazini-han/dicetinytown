# 모든 버튼, 주사위 클릭, 타일 클릭에 대한 반응
# Undo 기능을 위한 Command Stack 존재

extends Node

enum State {  # 상태 열거형
	READY,
	DICE_PHASE,
	SHAPE_PHASE,
	BUILDING_PHASE,
	NATURE_PHASE,
}

var DiceManager
var TileManager

var command_stack = []
var init_state = "READY" # 세이브 기능 사용시 변경
var current_state

func _ready():
	state_change(init_state)


func set_dice_manager(manager):
	DiceManager = manager
	DiceManager.connect("dice_to_slot", self, "_on_dice_to_slot")
	DiceManager.connect("slots_changed", self, "_on_slots_changed")


func set_tile_manager(manager):
	TileManager = manager
	TileManager.connect("selected_tile", self, "_on_selected_tile")
	TileManager.connect("board_changed", self, "_on_board_changed")

# Buttons Control
func _on_BackToMenu_pressed():
	GameManager.scene_change("START_MENU")


func _on_ButtonRollDice_pressed():
	DiceManager.roll_dice()
	
	state_change("DICE_PHASE")
	command_stack.clear()
	$ButtonRollDice.disabled = true


func _on_ButtonUndo_pressed():
	var last_command = command_stack.pop_back()
	last_command.undo()
	if command_stack.size() == 0:
		$ButtonUndo.disabled = true
	

# Clicks Control
func _on_dice_to_slot(dice, slot_index):
	var command = DiceToSlotCommand.new(dice,slot_index,DiceManager)
	command.execute()
	command_stack.append(command)
	$ButtonUndo.disabled = false


func _on_slots_changed(slot_occupied):
	var first_unoccupied_index = 3
	for i in range(slot_occupied.size()):
		if slot_occupied[i] == null:
			first_unoccupied_index = i	
	if first_unoccupied_index == 3:
		state_change("SHAPE_PHASE")
	elif current_state == "SHAPE_PHASE":
		state_change("DICE_PHASE")

# 단계 변화에 따른 인풋 컨트롤은 여기서 한다
func state_change(phase):
	current_state = phase
	print("STATE: ", phase)
	if phase == "READY":
		$ButtonRollDice.disabled = false
		$ButtonUndo.disabled = true
	elif phase == "DICE_PHASE":
		$ButtonRollDice.disabled = true		
	elif phase == "SHAPE_PHASE":
		pass # tile 클릭 가능하도록 변경
	elif phase == "BUILDING_PHASE":
		pass # 특정 타일만 클릭 가능하도록 변경
	elif phase == "NATURE_PHASE":
		pass
	else:
		print("ERROR: ", phase, " state is not defined")
	


# Command List
class DiceToSlotCommand:
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

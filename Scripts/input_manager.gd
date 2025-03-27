# 모든 버튼, 주사위 클릭, 타일 클릭에 대한 반응
# Undo 기능을 위한 Command Stack 존재

extends Node

signal filled_star(fill)

enum State {  # 상태 열거형
	READY,
	DICE_PHASE,
	SHAPE_PHASE,
	BUILDING_PHASE,
	NATURE_PHASE,
	END_PHASE,
}

var DiceManager
var TileManager

var command_stack = []
var init_state = State.READY # 세이브 기능 사용시 변경
var current_state
var tile_selectable
var count_nature = 0

func _ready():
	state_change(init_state)
	GameManager.connect("shape_button_disable", self, "_on_shape_button_disable")


func set_dice_manager(manager):
	DiceManager = manager
	DiceManager.connect("dice_to_slot", self, "_on_dice_to_slot")
	DiceManager.connect("slot_state_changed", self, "_on_slot_state_changed")


func set_tile_manager(manager):
	TileManager = manager
	TileManager.connect("selected_tile", self, "_on_selected_tile")
	TileManager.connect("board_changed", self, "_on_board_changed")


##########################
#     Buttons Control
##########################
func _on_ButtonRollDice_pressed():
	DiceManager.roll_dice()
	state_change(State.DICE_PHASE)
	command_stack.clear()
	$ButtonRollDice.disabled = true
	$ButtonUndo.disabled = true


func _on_ButtonUndo_pressed():
	var last_command = command_stack.pop_back()
	last_command.undo()
	if command_stack.size() == 0:
		$ButtonUndo.disabled = true


func _on_shape_button_disable(disable):
	$ButtonFlip.disabled = disable
	$ButtonRotate.disabled = disable


##########################
# Clicks Control
##########################
func _on_dice_to_slot(dice, slot_index):
	var command = DiceToSlotCommand.new(dice,slot_index,DiceManager)
	command.execute()
	command_stack.append(command)
	$ButtonUndo.disabled = false


func _on_slot_state_changed(slot_occupied):
	var first_unoccupied_index = 3
	for i in range(slot_occupied.size()):
		if slot_occupied[i] == null:
			first_unoccupied_index = i	
	if first_unoccupied_index == 3:
		state_change(State.SHAPE_PHASE)
	elif current_state == State.SHAPE_PHASE:
		state_change(State.DICE_PHASE)


# 단계 변화에 따른 인풋 컨트롤은 여기서 한다
func state_change(new_state):
	current_state = new_state	
	print("STATE: ", State.keys()[new_state])
	if new_state == State.READY:
		$ButtonRollDice.disabled = false
		$ButtonUndo.disabled = true
	elif new_state == State.DICE_PHASE:
		$ButtonRollDice.disabled = true	
		tile_selectable = false
		count_nature = 0
	elif new_state == State.SHAPE_PHASE:
		tile_selectable = true
	elif new_state == State.BUILDING_PHASE:
		tile_selectable = true
	elif new_state == State.NATURE_PHASE:
		tile_selectable = true
		$ButtonRollDice.disabled = true
	elif new_state == State.END_PHASE:
		tile_selectable = false
		$ButtonRollDice.disabled = false		
	else:
		print("ERROR: ", State.keys()[new_state], " state is not defined")
	

func _on_selected_tile(selected_tiles):
	if current_state == State.SHAPE_PHASE:
		var command = ShapeSelectCommand.new(selected_tiles, self)
		command.execute()
		command_stack.append(command)
	elif current_state == State.BUILDING_PHASE:
		var command = BuildingSelectCommand.new(selected_tiles[0], self)
		command.execute()
		command_stack.append(command)
	elif current_state == State.NATURE_PHASE:
		count_nature += 1
		var command = NatureSelectCommand.new(selected_tiles[0], self, count_nature)
		command.execute()
		command_stack.append(command)
	
		pass

	

########################
#     Command List
########################
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


class ShapeSelectCommand:
	var tiles
	var input_manager
	
	func _init(tile_nodes, node):
		tiles = tile_nodes
		input_manager = node
		
	func execute():
		for tile in tiles:
			tile.set_state("Filled")
		print("EXECUTE: ShapeSelect COMMAND")
		input_manager.state_change(input_manager.State.BUILDING_PHASE)
		
	func undo():
		for tile in tiles:
			tile.set_state("Empty")
		print("UNDO: ShapeSelect COMMAND")
		input_manager.state_change(input_manager.State.SHAPE_PHASE)


class BuildingSelectCommand:
	var tile
	var input_manager
	
	func _init(tile_node, node):
		tile = tile_node
		input_manager = node
		
	func execute():
		tile.set_state("Temped")
		print("EXECUTE: BuildingSelect COMMAND")
		input_manager.state_change(input_manager.State.NATURE_PHASE)
		
	func undo():
		tile.set_state("Filled")
		print("UNDO: BuildingSelect COMMAND")
		input_manager.state_change(input_manager.State.BUILDING_PHASE)


class NatureSelectCommand:
	var tile
	var input_manager
	var count
	
	func _init(tile_node, node, count_nature):
		tile = tile_node
		input_manager = node
		count = count_nature
		
		
	func execute():
		tile.set_state("Temped")
		print("EXECUTE: NatureSelect COMMAND")
		if count == 2:
			input_manager.state_change(input_manager.State.END_PHASE)
	func undo():
		tile.set_state("Filled")
		print("UNDO: NatureSelect COMMAND")
		input_manager.count_nature -= 1
		count -= 1
		if count == 1:
			input_manager.state_change(input_manager.State.NATURE_PHASE)
		elif count == 0:
			input_manager.state_change(input_manager.State.BUILDING_PHASE)
		


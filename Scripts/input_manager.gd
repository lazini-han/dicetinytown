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

var command_stack = []
var init_state = "READY" # 세이브 기능 사용시 변경
var current_state

func _ready():
	state_change(init_state)


func set_dice_manager(manager):
	DiceManager = manager
	DiceManager.connect("dice_to_slot", self, "_on_dice_to_slot")


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
	var command = DiceToSlotCommand.new(dice,slot_index, DiceManager)
	command.execute()
	command_stack.append(command)
	$ButtonUndo.disabled = false


# 단계 변화에 따른 인풋 컨트롤은 여기서 한다
func state_change(phase):
	current_state = phase
	if phase == "READY":
		$ButtonRollDice.disabled = false
	elif phase == "DICE_PHASE":
		$ButtonRollDice.disabled = true		
	elif phase == "SHAPE_PHASE":
		pass
	elif phase == "BUILDING_PHASE":
		pass
	elif phase == "NATURE_PHASE":
		pass
	else:
		print("ERROR: ", phase, " state is not defined")

# dice_system.gd
class_name DiceSystem
extends Node

signal dice_rolled(dice_values)  # 주사위를 굴렸을 때
signal dice_placed_in_slot(dice, slot_type, dice_value)  # 주사위가 슬롯에 배치되었을 때
signal all_dice_placed  # 모든 주사위가 배치되었을 때
signal slot_action_performed(slot_type, dice_value)  # 슬롯 액션이 수행되었을 때

const SLOT_TYPE = {
	"SHAPE": 0,
	"BUILDING": 1,
	"NATURE": 2
}

var dice_manager = null


# 초기화
func _ready():
		
	# 이벤트 연결
	dice_manager.connect("dice_selected", self, "_on_dice_selected")
	dice_manager.connect("dice_rolled", self, "_on_dice_rolled")
	slot_manager.connect("dice_placed", self, "_on_dice_placed_in_slot")


# 시스템 초기화
func initialize(dice_nodes, dice_positions, roll_positions, slot_nodes):
	dice_manager.initialize(dice_nodes, dice_positions, roll_positions)
	slot_manager.initialize(slot_nodes)


# 주사위 굴리기
func roll_dice():
	# 모든 슬롯 초기화
	slot_manager.reset_all_slots()
	
	# 명령 스택 초기화
	GameManager.command_stack.clear()
	
	# 주사위 굴리기
	return dice_manager.roll_all_dice()


# 주사위가 선택되었을 때
func _on_dice_selected(dice):
	# 이미 슬롯에 배치된 주사위인지 확인
	var existing_slot = slot_manager.find_slot_for_dice(dice)
	if existing_slot >= 0:
		print("이미 슬롯에 배치된 주사위입니다.")
		return
	
	# 빈 슬롯 찾기
	var slot_index = slot_manager.find_empty_slot()
	if slot_index < 0:
		print("사용 가능한 슬롯이 없습니다.")
		return
	
	# 주사위를 슬롯에 배치
	var target_position = slot_manager.place_dice_in_slot(dice, slot_index) # 슬롯에 배치됨을 인식
	if target_position: # 슬롯에 주사위가 배치 가능한 경우
		var target_slot = slot_manager.get_slot(slot_index)
		var command = DiceMoveToSlotCommand.new(dice, target_slot)
		command.execute()
		GameManager.command_stack.append(command)
		
		dice_manager.move_dice(dice, target_position)
	

# 모든 주사위가 굴려졌을 때
func _on_dice_rolled(dice_values):
	emit_signal("dice_rolled", dice_values)
	
	
# 주사위가 슬롯에 배치되었을 때
func _on_dice_placed_in_slot(dice, slot, slot_index):
	var slot_type = get_slot_type(slot)
	emit_signal("dice_placed_in_slot", dice, slot_type, dice.dice_value)
	
	# 특정 슬롯 유형에 따른 액션 수행
	perform_slot_action(slot_type, dice.dice_value)
	
	# 모든 주사위가 배치되었는지 확인
	if slot_manager.find_empty_slot() < 0:
		emit_signal("all_dice_placed")
		

# 슬롯 유형 얻기
func get_slot_type(slot):
	if slot.name == "SlotShape":
		return SLOT_TYPE.SHAPE
	elif slot.name == "SlotBuilding":
		return SLOT_TYPE.BUILDING
	elif slot.name == "SlotNature":
		return SLOT_TYPE.NATURE
	return -1


# 슬롯 유형에 따른 액션 수행
func perform_slot_action(slot_type, dice_value):
	match slot_type:
		SLOT_TYPE.SHAPE:
			# 모양 선택 액션
			print("모양 선택: " + str(dice_value))
		SLOT_TYPE.BUILDING:
			# 건물 선택 액션
			print("건물 선택: " + str(dice_value))
		SLOT_TYPE.NATURE:
			# 자연 선택 액션
			print("자연 선택: " + str(dice_value))
	
	emit_signal("slot_action_performed", slot_type, dice_value)

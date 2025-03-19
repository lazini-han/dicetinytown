# slot_manager.gd
class_name SlotManager
extends Node

signal dice_placed(dice, slot, slot_index)  # 주사위가 슬롯에 배치되었을 때
signal slot_emptied(slot, slot_index)  # 슬롯이 비워졌을 때

var slots = []  # 슬롯 참조 목록
var slot_occupancy = []  # 슬롯 점유 상태 (true: 점유됨, false: 비어있음)
var slot_dice = []  # 각 슬롯에 배치된 주사위
var target_slot_index = 0  # 다음에 사용할 슬롯 인덱스


# 초기화
func initialize(slot_nodes):
	slots = slot_nodes
	slot_occupancy.resize(slots.size()) # 배열 크기 = 슬롯 갯수
	slot_dice.resize(slots.size())  # 배열 크기 = 슬롯 갯수
	
	for i in range(slots.size()):
		slot_occupancy[i] = false
		slot_dice[i] = null
	
	target_slot_index = 0


# 슬롯에 주사위 배치
func place_dice_in_slot(dice, slot_index = -1):
	# 슬롯 인덱스가 지정되지 않았으면 자동으로 다음 빈 슬롯 사용
	if slot_index < 0:
		slot_index = find_empty_slot()
	
	# 유효한 슬롯 확인
	if slot_index < 0 or slot_index >= slots.size():
		print("ERROR: 유효하지 않은 슬롯 인덱스 - " + str(slot_index))
		return null
	
	# 이미 점유된 슬롯인지 확인
	if slot_occupancy[slot_index]:
		print("WARNING: 이미 점유된 슬롯 - " + str(slot_index))
		return null
	
	# 주사위를 슬롯에 배치
	var slot = slots[slot_index] # 슬롯 객체 선택
	var slot_position = slot.global_position + slot.get_node("Sprite").texture.get_size() / 2 # 슬롯 위치 파악
	
	# 슬롯 상태 업데이트
	slot_occupancy[slot_index] = true
	slot_dice[slot_index] = dice
	
	# 다음 대상 슬롯 인덱스 업데이트
	if target_slot_index == slot_index:
		target_slot_index = find_empty_slot()
	
	emit_signal("dice_placed", dice, slot, slot_index)
	return slot_position # 슬롯 위치를 전달
	
	
# 슬롯에서 주사위 제거
func remove_dice_from_slot(slot_index):
	# 유효한 슬롯 index 체크 & 주사위 점유 확인
	if slot_index >= 0 and slot_index < slots.size() and slot_occupancy[slot_index]:
		var dice = slot_dice[slot_index]
		slot_occupancy[slot_index] = false
		slot_dice[slot_index] = null
		
		# 대상 슬롯 인덱스 업데이트
		if target_slot_index > slot_index or target_slot_index == slots.size():
			target_slot_index = slot_index
		
		emit_signal("slot_emptied", slots[slot_index], slot_index)
		return dice # 슬롯에서 나간 주사위 전달
	
	return null


# 비어있는 슬롯 찾기
func find_empty_slot():
	for i in range(slots.size()):
		if not slot_occupancy[i]:
			return i
	return -1


# 특정 주사위가 놓인 슬롯 찾기
func find_slot_for_dice(dice):
	for i in range(slots.size()):
		if slot_dice[i] == dice:
			return i
	return -1


# 모든 슬롯 초기화
func reset_all_slots():
	for i in range(slots.size()):
		slot_occupancy[i] = false
		slot_dice[i] = null
	
	target_slot_index = 0


# 특정 슬롯 상태 확인
func is_slot_occupied(slot_index):
	if slot_index >= 0 and slot_index < slots.size():
		return slot_occupancy[slot_index]
	return false


# 슬롯 가져오기
func get_slot(slot_index):
	if slot_index >= 0 and slot_index < slots.size():
		return slots[slot_index]
	return null


# 슬롯에 배치된 주사위 가져오기
func get_dice_at_slot(slot_index):
	if slot_index >= 0 and slot_index < slots.size():
		return slot_dice[slot_index]
	return null

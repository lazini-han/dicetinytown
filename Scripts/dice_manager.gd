# Dice & Slot Manager
# 주사위와 슬롯들 상태를 컨트롤하는 클래스 

class_name DiceManager
extends Node

signal dice_to_slot(dice,slot_index)
signal slot_state_changed(slot_occupied)

var random_numbers: Array  # 주사위 랜덤 결과 목록 받아옴
var dice_list: Array 
var dice_positions: Array 
var slot_list: Array 
var target_slot_index: int
var slot_occupied: Array = [null, null, null]


func set_random_numbers(value_list: Array): # Stage 시작시 매서드 호출로 받아오기
	random_numbers = value_list.duplicate()


# 주사위 초기화
func initialize(dice_nodes, position_nodes, slot_nodes):
	print("DiceManager initialize")
	dice_list = dice_nodes
	dice_positions = position_nodes 
	slot_list = slot_nodes
	target_slot_index = 0
	
	# 각 주사위 이벤트 연결
	for i in range(dice_list.size()):
		dice_list[i].connect("clicked", self, "_on_dice_clicked")
		dice_list[i].dice_sprites = GameManager.dice_sprites
		dice_list[i].dice_index = i
		reset_dice(i)
	# 각 슬롯 이벤트 연결
	for i in range(slot_list.size()):
		slot_list[i].connect("slot_changed", self, "_on_slot_changed")


# 주사위 초기화 : 초기 위치, 보이지 않고 값을 없엔 상태
func reset_dice(index):
	if index >= 0 and index < dice_list.size() and index < dice_positions.size():
		dice_list[index].dice_index = index
		dice_list[index].position = dice_positions[index].position
		dice_list[index].set_dice(0)  
		dice_list[index].visible = false


# 주사위 굴리기
func roll_dice():	
	if random_numbers.size() < dice_list.size():
		# 콘솔 로그와 함께 사용자에게 알림
		print("WARNING: 남은 랜덤값이 주사위수보다 적습니다. 새로운 값을 생성합니다.")
		# 부족한 값을 실제 랜덤 값으로 채움
		while random_numbers.size() < dice_list.size():
			random_numbers.append(randi() % 6 + 1) # 1~6 사이의 랜덤값
		
		# 선택적으로 사용자에게 피드백 제공
		# var popup = load("res://UI/warning_popup.tscn").instance()
		# popup.set_message("주사위 데이터를 재생성했습니다.")
		# add_child(popup)

	# 각 주사위 위치 및 값 설정
	for i in range(dice_list.size()):
		reset_dice(i)
		var roll_value = random_numbers.pop_front() 
		dice_list[i].set_dice(roll_value)
		dice_list[i].visible = true
		print("주사위 " + str(i) + " 결과: " + str(roll_value))
	
	# 슬롯 정보 비우기
	target_slot_index = 0
	slot_occupied = [null, null, null]
	GameManager.emit_signal("tempted_tile_fixed")


# 주사위를 슬롯으로 보낼때
func dice_move_to_slot(dice, slot_index):
	slot_occupied[slot_index] = dice
	dice.position = slot_list[slot_index].get_node("Sprite").global_position
	emit_signal("slot_state_changed", slot_occupied)
	target_slot_index += 1


# 주사위를 슬롯에서 뺄따
func dice_move_back(dice, slot_index):
	slot_occupied[slot_index] = null
	dice.position = dice_positions[dice.dice_index].position
	emit_signal("slot_state_changed", slot_occupied)
	target_slot_index -= 1


func _on_dice_clicked(dice):
	for idice in slot_occupied: # 현재 주사위가 slot에 있다면 클릭 무시
		if idice == dice:
			print("The clicked dice is already in an slot.")
			return
			
	emit_signal("dice_to_slot", dice, target_slot_index)


func _on_slot_changed(slot_type, value):
	if slot_type == "Shape":
		GameManager.emit_signal("slot_shape_change", value)
	elif slot_type == "Building":
		GameManager.emit_signal("slot_building_change", value)
	elif slot_type == "Nature":
		GameManager.emit_signal("slot_nature_change", value)
	else:
		print(slot_type, " is not defined.")


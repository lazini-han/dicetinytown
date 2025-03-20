# Dice & Slot Manager
# 주사위와 슬롯들 상태를 컨트롤하는 클래스 

class_name DiceManager
extends Node

var random_numbers: Array  # 주사위 랜덤 결과 목록 받아옴
var dice_list: Array 
var dice_positions: Array 
var slot_list: Array 

func _ready():
	# InputManager 노드를 찾아서 시그널 연결
	var input_manager = get_node("../InputManager")
	input_manager.connect("roll_dice", self, "_on_roll_dice")
	

func set_random_numbers(value_list: Array): # Stage 시작시 매서드 호출로 받아오기
	random_numbers = value_list.duplicate()


# 주사위 초기화
func initialize(dice_nodes, position_nodes, slot_nodes):
	dice_list = dice_nodes
	dice_positions = position_nodes 
	slot_list = slot_nodes
	
	# 각 주사위 이벤트 연결
	for i in range(dice_list.size()):
		dice_list[i].connect("clicked", self, "_on_dice_clicked")
		dice_list[i].dice_sprites = GameManager.dice_sprites
		reset_dice(i)
		

# 주사위 초기화 : 초기 위치, 보이지 않고 값을 없엔 상태
func reset_dice(index):
	if index >= 0 and index < dice_list.size() and index < dice_positions.size():
		dice_list[index].dice_index = index
		dice_list[index].position = dice_positions[index].position
		dice_list[index].set_dice(0)  
		dice_list[index].visible = false
			

	
# 주사위 굴리기
func _on_roll_dice():	
	# 각 주사위 위치 및 값 설정
	for i in range(dice_list.size()):
		reset_dice(i)
		var roll_value = random_numbers.pop_front() 
		dice_list[i].set_dice(roll_value)
		dice_list[i].visible = true
		print("주사위 " + str(i) + " 결과: " + str(roll_value))


# 주사위를 슬롯으로 보낼때
func _on_dice_to_slot(dice, slot):
	pass

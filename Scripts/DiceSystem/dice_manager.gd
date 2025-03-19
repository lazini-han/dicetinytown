# dice_manager.gd
class_name DiceManager
extends Node

signal dice_rolled(dice_values)  # 모든 주사위를 굴렸을 때
signal dice_selected(dice)  # 주사위가 선택되었을 때

export var dice_count: int = 3  # 관리할 주사위 개수

var dice_list = []  # 주사위 객체 목록
var random_numbers = []  # 주사위 랜덤 결과 목록
var starting_positions = []  # 초기 위치 목록
var rolling_positions = []  # 굴림 후 위치 목록
var current_seed = 0  # 현재 랜덤 시드
var number_of_random = 30 # 생성할 랜덤 넘버 갯수


# 초기화
func _ready():
	# 굴림 관련 랜덤 시드 설정
	randomize_with_date_seed(number_of_random, "Time") # Date 면 날짜 기반, Time 이면 항상 다르게


# 주사위 초기화
func initialize(dice_nodes, start_positions, roll_positions):
	dice_list = dice_nodes # 초기화시 주사위 노드들 입력
	starting_positions = start_positions # 주사위 초기 위치 입력 보이지 않는 곳
	rolling_positions = roll_positions   # 굴려진 주사위가 보이는 곳 위치 목록
	
	# 각 주사위 이벤트 연결
	for i in range(dice_list.size()):
		dice_list[i].connect("clicked", self, "_on_dice_clicked")
		reset_dice_position(i)
		

# 주사위 위치 초기화
func reset_dice_position(index):
	if index >= 0 and index < dice_list.size() and index < starting_positions.size():
		dice_list[index].position = starting_positions[index]
		dice_list[index].set_dice(0)  # 값도 초기화
		

# 특정 주사위 가져오기
func get_dice(index):
	if index >= 0 and index < dice_list.size():
		return dice_list[index]
	return null
	
	
# 모든 주사위 굴리기
func roll_all_dice():
	# 랜덤 숫자 생성
	random_numbers = generate_random_numbers(dice_list.size())
	
	# 각 주사위 위치 및 값 설정
	for i in range(dice_list.size()):
		if i < rolling_positions.size():
			dice_list[i].position = rolling_positions[i] # 주사위 위치 옮김
		
		var roll_value = random_numbers[i] # 배열의 값을 일부러 변수로 저장
		dice_list[i].set_dice(roll_value)  # 저장한 변수 값으로 주사위 값 변경
		
		print("주사위 " + str(i) + " 결과: " + str(roll_value))
	
	emit_signal("dice_rolled") # 주사위 굴리기가 끝남을 신호


func generate_random_numbers(count):
	var numbers = []
	for i in range(count):
		numbers.append((randi() % 6) + 1)
	return numbers


# 날짜를 시드로 설정하는 함수
func randomize_with_date_seed(number_of_random, option):
	randomize()  # 기본 랜덤화
	if option == "Date":
		var current_date = Time.get_date_dict_from_system()
		var seed_value = current_date["year"] * 10000 + current_date["month"] * 100 + current_date["day"]
		seed(seed_value)  # 날짜를 시드로 설정
		current_seed = seed_value
	elif option == "Time":
		pass

	# 초기 랜덤 숫자 생성
	for i in range(number_of_random):  # 충분한 수의 랜덤 숫자 생성
		random_numbers.append((randi() % 6) + 1)


# 주사위가 클릭되었을 때
func _on_dice_clicked(dice):
	emit_signal("dice_selected", dice)
	

# 특정 주사위 이동
func move_dice(dice, target_position):
	dice.global_position = target_position

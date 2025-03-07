extends Node

# 게임 상태 열거형
enum TurnState { 
	READY,
	DICE_FREE,
	DICE_1_OCCUPIED,
	DICE_2_OCCUPIED,
	DICE_3_OCCUPIED
	}

var current_state = null
var current_state_node = null
var state_nodes = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("roll_dice", self, "_on_roll_dice") # 주사위가 굴림 결과 받기
	Eventbus.connect("confirm_dice", self, "_on_confirm_dice") # 주사위가 굴림 결과 받기
	# 자식 노드들을 상태 노드로 등록
	for child in get_children():
		if child.has_method("get_state_enum"):
			var state_enum = child.get_state_enum()
			state_nodes[state_enum] = child
			print(state_enum)
	
	# 한 프레임 기다리기
	yield(get_tree(), "idle_frame")
	
	# 시작 상태 
	change_state(TurnState.READY)
	

func change_state(new_state_enum):
	# 이전 상태 종료
	if current_state_node != null:
		current_state_node.exit()
	
	# 새 상태 설정
	current_state = new_state_enum
	current_state_node = state_nodes[new_state_enum]
	
	# 새 상태 시작
	if current_state_node != null:
		current_state_node.enter()
	
	#Eventbus.emit_signal("state_changed", current_state) 
	print("state_changed to ", current_state)

func _on_roll_dice():
	change_state(TurnState.DICE_FREE)
	
func _on_confirm_dice():
	change_state(TurnState.READY)
	
# 현재 상태 열거형 값 반환
func get_current_state():
	return current_state

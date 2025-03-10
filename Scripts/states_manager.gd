extends Node
# 상태를 관리하고 변경하는 작업 진행하는 노드 

enum TurnState {  # 상태 열거형
	READY,
	DICE_FREE,
	DICE_OCCUPIED,
}

var current_state = null
var current_state_node = null
var state_nodes = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("state_changed", self, "_on_state_changed") # 주사위가 굴림 결과 받기
	
	for child in get_children(): # 자식 노드들을 상태 노드로 등록
		if child.has_method("get_state_enum"):
			var state_enum = child.get_state_enum()
			state_nodes[state_enum] = child
			print(state_enum)
	
	yield(get_tree(), "idle_frame") # 시작 상태 설정 전에 한 프레임 기다리기
	change_state(TurnState.READY) # 시작 상태 


func change_state(new_state_enum): # 상태 변경 함수 
	if current_state_node != null: # 이전 상태 종료
		current_state_node.exit()
	
	current_state = new_state_enum # 새 상태 설정
	current_state_node = state_nodes[new_state_enum]
	
	if current_state_node != null: # 새 상태 시작
		current_state_node.enter()
	
	print("state_changed to STATE ", current_state)


func _on_state_changed(new_state_name): # 외부에서 상태 변화 신호를 받아서 상태 변경해주기
	print("emit state changging to ", new_state_name, " ", TurnState[new_state_name])
	var new_state_enum = TurnState[new_state_name]
	change_state(new_state_enum)


func get_current_state(): # 현재 상태 열거형 값 반환
	return current_state

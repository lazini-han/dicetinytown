extends "res://basestate.gd"

# READY 상태 구현

func get_state_enum():
	# 부모 노드에서 TurnState.READY 반환
	return get_parent().TurnState.DICE_2_OCCUPIED

func enter():
	print("상태 진입: DICE 2 OCCUPIED")
	# 게임 시작 준비 상태 진입 로직
	# 예: 턴 시작 메시지 표시, 주사위 활성화 등
	
func exit():
	print("상태 종료: DICE 2 OCCUPIED")
	# READY 상태 종료 시 필요한 처리
	
func process(delta):
	# READY 상태에서의 프레임별 처리 로직
	pass

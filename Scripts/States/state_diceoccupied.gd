extends "res://Scripts/States/basestate.gd"

# DICE_OCCUPIED 상태 구현

func get_state_enum():
	return get_parent().TurnState.DICE_OCCUPIED # 부모 노드에서 TurnState.READY 반환


func enter():
	print("상태 진입: DICE OCCUPIED")
	# 블록 보여주기
	

func exit():
	print("상태 종료: DICE OCCUPIED")
	# 블록 보여주기


#func process(delta):
	# READY 상태에서의 프레임별 처리 로직
	#pass

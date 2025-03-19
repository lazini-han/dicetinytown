extends "res://Scripts/States/basestate.gd"

# READY 상태 구현

func get_state_enum():
	return get_parent().TurnState.READY # 부모 노드에서 TurnState.READY 반환


func enter():
	print("상태 진입: READY")

	

func exit():
	print("상태 종료: READY")
	

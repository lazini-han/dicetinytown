extends "res://Scripts/States/basestate.gd"

# DICE_FREE 상태 구현

func get_state_enum():
	return get_parent().TurnState.DICE_FREE # 부모 노드에서 TurnState.READY 반환

	
func enter():
	print("상태 진입: DICE_FREE")
	
	#get_parent().get_parent().command_stack = [] 
	

func exit():
	print("상태 종료: DICE_FREE")


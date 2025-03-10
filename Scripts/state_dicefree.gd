extends "res://Scripts/NoConnect/basestate.gd"

# DICE_FREE 상태 구현

func get_state_enum():
	return get_parent().TurnState.DICE_FREE # 부모 노드에서 TurnState.READY 반환

	
func enter():
	print("상태 진입: DICE_FREE")
	Eventbus.emit_signal("change_target_slot","Shape") # 주사위 타깃 
	

func exit():
	print("상태 종료: DICE_FREE")


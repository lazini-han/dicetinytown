extends "res://Scripts/States/basestate.gd"

# DICE_OCCUPIED 상태 구현

func get_state_enum():
	return get_parent().TurnState.SHAPE_SELECTED # 부모 노드에서 TurnState.READY 반환


func enter():
	print("상태 진입: SHAPE_SELECTED")
	Eventbus.emit_signal("build_ready", true) # 보드판에 빌딩 준비
	

func exit():
	print("상태 종료: SHAPE_SELECTED")
	Eventbus.emit_signal("build_ready", false) # 보드판에 빌딩 준비 해제



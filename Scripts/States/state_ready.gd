extends "res://Scripts/States/basestate.gd"

# READY 상태 구현

func get_state_enum():
	return get_parent().TurnState.READY # 부모 노드에서 TurnState.READY 반환


func enter():
	print("상태 진입: READY")
	Eventbus.emit_signal("ButtonRollDice_change",true) # 주사위 굴림 활성화
	Eventbus.emit_signal("ButtonUndo_change",false) # 주사위 확정 버튼 비활성화
	

func exit():
	print("상태 종료: READY")
	Eventbus.emit_signal("ButtonRollDice_change",false) # 주사위 굴림 버튼 비활성화
	

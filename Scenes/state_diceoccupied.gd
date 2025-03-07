extends "res://basestate.gd"

# READY 상태 구현

func get_state_enum():
	# 부모 노드에서 TurnState.READY 반환
	return get_parent().TurnState.DICE_OCCUPIED

func enter():
	print("상태 진입: DICE OCCUPIED")
	# 주사위 확정 버튼 활성화
	Eventbus.emit_signal("button_confirm_dice",true)
	
func exit():
	print("상태 종료: DICE OCCUPIED")
	# 주사위 확정 버튼 비활성화
	Eventbus.emit_signal("button_confirm_dice",false)
	
#func process(delta):
	# READY 상태에서의 프레임별 처리 로직
	#pass

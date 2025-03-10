extends "res://Scripts/NoConnect/basestate.gd"

# READY 상태 구현

func get_state_enum():
	return get_parent().TurnState.READY # 부모 노드에서 TurnState.READY 반환


func enter():
	print("상태 진입: READY")
	Eventbus.emit_signal("button_roll_dice",true) # 주사위 굴림 활성화
	Eventbus.emit_signal("button_confirm_dice",false) # 주사위 확정 버튼 비활성화


func exit():
	print("상태 종료: READY")
	Eventbus.emit_signal("button_roll_dice",false) # 주사위 굴림 버튼 비활성화
	#Eventbus.emit_signal("button_confirm_dice",true) # 주사위 확정 버튼 활성화
	#Eventbus.emit_signal("dice_movable",true) # 주사위 이동 활성화


#func process(delta):
	# READY 상태에서의 프레임별 처리 로직
#	pass

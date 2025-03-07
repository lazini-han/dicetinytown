extends Node

signal roll_dice # 주사위 굴리기 요청
signal confirm_dice # 주사위 배치 결정
signal slot_1_occupied(dice) # 주사위 채워짐 1 
signal slot_2_occupied(dice) # 주사위 채워짐 2
signal slot_3_occupied(dice) # 주사위 채워짐 3
signal state_changed(new_state)

signal button_roll_dice(active) # 버튼을 활성화 여부
signal button_confirm_dice(active) # 버튼을 활성화 여부

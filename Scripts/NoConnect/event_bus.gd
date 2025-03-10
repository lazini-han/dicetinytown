extends Node

signal state_changed(new_state_enum) # state_manager 외의 다른 노드에서 상태 변경 신호

signal roll_dice # 주사위 굴리기 요청
signal confirm_dice # 주사위 배치 결정

signal button_roll_dice(active) # 버튼을 활성화 여부
signal button_confirm_dice(active) # 버튼을 활성화 여부

signal clicked_dice(dice) # 주사위를 클릭함
signal change_target_slot(slot_name) # 클릭하면 마우스가 이동할 슬롯 변경

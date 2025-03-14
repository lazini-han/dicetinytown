extends Node

signal state_changed(new_state_enum) # state_manager 외의 다른 노드에서 상태 변경 신호

signal roll_dice # 주사위 굴리기 요청
signal confirm_dice # 주사위 배치 결정

# 버튼을 활성화 변경
signal ButtonRollDice_change(active) 
signal ButtonConfirmDice_change(active)

signal clicked_dice(dice) # 주사위를 클릭함
signal target_slot_update() # 주사위 이동시 target slot 변경

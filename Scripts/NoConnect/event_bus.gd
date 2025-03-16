extends Node

signal state_changed(new_state_enum) # state_manager 외의 다른 노드에서 상태 변경 신호

signal roll_dice # 주사위 굴리기 요청
signal confirm_dice # 주사위 배치 결정

# 버튼을 활성화 변경
signal ButtonRollDice_change(active) 
signal ButtonUndo_change(active)

signal clicked_dice(dice) # 주사위를 클릭함

signal tile_ready(active) # 보드에 타일 놓기 가능 상태
signal shape_selected(shape_type) # 블록 모양 결정

signal mouse_on_tile(grid_position) # 타일에 올라간 마우스 인식
signal mouse_off_tile(grid_position) # 타일에 올라간 마우스 인식

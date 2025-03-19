# warning-ignore-all:unused_signal
extends Node

signal state_changed(new_state_enum) # state_manager 외의 다른 노드에서 상태 변경 신호

# 버튼을 활성화 변경
signal ButtonRollDice_change(active) 
signal ButtonUndo_change(active)

signal clicked_tile(grid_position, board) # 타일을 클릭

signal tile_ready(active) # 보드에 타일 놓기 가능 상태
signal shape_selected(shape_type) # 블록 모양 결정

signal mouse_on_tile(grid_position, board) # 타일에 올라간 마우스 인식
signal mouse_off_tile(grid_position, board) # 타일에 올라간 마우스 인식

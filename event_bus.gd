extends Node

signal roll_dice # 주사위 굴리기 요청
signal roll_result(dice_id, dice_value) # 주사위 결과 전달 신호
signal cannot_roll # 주사위 굴리기 버튼 비활성화
signal show_score_button # 점수 계산 버튼 보이기
signal go_to_score # 점수 계산 화면으로 가기

signal dice_in_slot(dice_name, slot_name) # dice 가 box에 들어감
signal dice_out_of_slot(dice_name, slot_name) # dice 가 box에서 나와서 초기위치로 
signal update_slot(slot_name, dice_name, dice_value)
signal teleport_dice(slot_name, dice_name, dice_value)

signal update_shape_label(dice_value) # 박스에 있는 주사위 id, 주사위 id별 값
signal update_building_label(dice_value) # 박스에 있는 주사위 id, 주사위 id별 값
signal update_nature_label(dice_value) # 박스에 있는 주사위 id, 주사위 id별 값
signal update_total(total) # 주사위 합 값을 바꾸기

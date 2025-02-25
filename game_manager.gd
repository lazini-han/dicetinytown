extends Node

# 게임 매니저 노드 
var this_round = 0     # 게임 라운드 = 주사위 굴림 버튼 횟수 제한
var max_round = 3 # 최대 3 라운드
var dice_value = [0, 0, 0]
const no_dice = 3 # for mark in box
var dice_in_box = [ no_dice, no_dice, no_dice] #
var score = 0
var total_rolled = 0

func _ready():
	EventBus.connect("roll_dice", self, "_on_roll_dice") # 주사위가 굴림 결과 받기
	EventBus.connect("go_to_score", self, "_on_go_to_score") # 점수 계산으로 장면 이동 
	EventBus.connect("roll_result", self, "_on_roll_result") #주사위 결과 전달 신호
	EventBus.connect("dice_in_box", self, "_on_dice_in_box") # dice 가 box에 들어감
	EventBus.connect("dice_out_of_box", self, "_on_dice_out_of_box") # dice 가 box에서 나와서 초기위치로 
	
func _on_roll_dice():
	this_round += 1
	total_rolled = 0
	if this_round == max_round: 
		EventBus.emit_signal("cannot_roll")
		EventBus.emit_signal("show_score_button")

func _on_roll_result(dice, value):
	dice_value[dice] = value
	total_rolled += value
	score += value
	EventBus.emit_signal("change_total", total_rolled)
	
func _on_go_to_score():
	get_tree().change_scene("res://ending_scene.tscn")
	
func _on_dice_in_box(dice, box_node):
	var box = box_node.this_box_number
	for i in range(3):
		if dice_in_box[i] == dice:
			dice_in_box[i] = no_dice	
	dice_in_box[box] = dice
	EventBus.emit_signal("change_label", dice_in_box, dice_value)
	
func _on_dice_out_of_box(dice):
	for i in range(3):
		if dice_in_box[i] == dice:
			dice_in_box[i] = no_dice			
	EventBus.emit_signal("change_label", dice_in_box, dice_value)

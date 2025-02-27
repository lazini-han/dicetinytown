extends Node

# 게임 매니저 노드 
var game_state = {
	"this_round": 0,	"last_round": 3,
	"dice_value": { # dice_values
		"Dice_0":0,
		"Dice_1":0,
		"Dice_2":0
		},
	"dice_in_box": [null, null, null], # dice_names in boxes
	"score": 0,	
}
var total_rolled = 0

func _ready():
	EventBus.connect("roll_dice", self, "_on_roll_dice") # 주사위가 굴림 결과 받기
	EventBus.connect("go_to_score", self, "_on_go_to_score") # 점수 계산으로 장면 이동 
	EventBus.connect("roll_result", self, "_on_roll_result") #주사위 결과 전달 신호
	EventBus.connect("dice_in_box", self, "_on_dice_in_box") # dice 가 box에 들어감
	EventBus.connect("dice_out_of_box", self, "_on_dice_out_of_box") # dice 가 box에서 나와서 초기위치로 
	
func _on_roll_dice():
	game_state["this_round"] += 1
	total_rolled = 0
	
	game_state["dice_in_box"] =  [null, null, null]
	EventBus.emit_signal("change_label", game_state["dice_in_box"], game_state["dice_value"])
	
	if game_state["this_round"] == game_state["last_round"]: 
		EventBus.emit_signal("cannot_roll")
		EventBus.emit_signal("show_score_button")

func _on_roll_result(dice_name, dice_value):
	print(dice_name, " rolled : ", dice_value)
	game_state["dice_value"][dice_name] = dice_value
	#print(game_state["dice_value"])
	total_rolled += dice_value
	game_state["score"] += dice_value
	EventBus.emit_signal("change_total", total_rolled)
	
func _on_go_to_score():
	get_tree().change_scene("res://ending_scene.tscn")
	
func _on_dice_in_box(dice_name, box_node):
	var box = box_node.this_box_number
	print(dice_name, " in ", box)
	for i in range(3):
		if game_state["dice_in_box"][i] == dice_name:
			game_state["dice_in_box"][i] = null	
	game_state["dice_in_box"][box] = dice_name
	EventBus.emit_signal("change_label", game_state["dice_in_box"], game_state["dice_value"])
	
func _on_dice_out_of_box(dice_name):
	print(dice_name, " out of box")
	for i in range(3):
		if game_state["dice_in_box"][i] == dice_name:
			game_state["dice_in_box"][i] = null
	EventBus.emit_signal("change_label", game_state["dice_in_box"], game_state["dice_value"])

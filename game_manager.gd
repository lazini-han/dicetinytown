extends Node

# 게임 매니저 노드 
var game_state = {
	"this_round": 0,	"last_round": 3,
	"dice_value": { # dice_values
		"Dice_0":0,
		"Dice_1":0,
		"Dice_2":0
		},
	"dice_position": {
		"Dice_0":null,
		"Dice_1":null,
		"Dice_2":null
	},
	"dice_in_slot": { # dice_names in slots
		"Slot_Shape": null,
		"Slot_Building": null,
		"Slot_Nature": null
		}, 
	"score": 0,	
}

var total_rolled = 0

func _ready():
	EventBus.connect("roll_dice", self, "_on_roll_dice") # 주사위가 굴림 결과 받기
	EventBus.connect("go_to_score", self, "_on_go_to_score") # 점수 계산으로 장면 이동 
	EventBus.connect("roll_result", self, "_on_roll_result") #주사위 결과 전달 신호
	EventBus.connect("dice_in_slot", self, "_on_dice_in_slot") # dice 가 slot에 들어감
	EventBus.connect("dice_out_of_slot", self, "_on_dice_out_of_slot") # dice 가 slot에서 나와서 초기위치로 
	print(typeof(game_state["dice_in_slot"])) # 딕셔너리 26번 확인 
	
func _on_roll_dice():
	game_state["this_round"] += 1
	total_rolled = 0
	
	game_state["dice_in_slot"] = { # 슬롯 초기화 
		"Slot_Shape": null,
		"Slot_Building": null,
		"Slot_Nature": null
		}
	#EventBus.emit_signal("update_label", game_state["dice_in_slot"], game_state["dice_value"])
	
	if game_state["this_round"] == game_state["last_round"]: 
		EventBus.emit_signal("cannot_roll")
		EventBus.emit_signal("show_score_button")

func _on_roll_result(dice_name, dice_value):
	print(dice_name, " rolled : ", dice_value)
	game_state["dice_value"][dice_name] = dice_value
	game_state["dice_position"][dice_name] = null
	#print(game_state["dice_value"])
	total_rolled += dice_value
	game_state["score"] += dice_value
	EventBus.emit_signal("update_slot", "Slot_Shape", null, "")
	EventBus.emit_signal("update_slot", "Slot_Building", null, "")
	EventBus.emit_signal("update_slot", "Slot_Nature", null, "")
	EventBus.emit_signal("update_total", total_rolled)
	
	
func _on_go_to_score():
	get_tree().change_scene("res://ending_scene.tscn")
	
func _on_dice_in_slot(dice_name, slot_name):
	print(dice_name, " in ", slot_name)
	print(typeof(game_state["dice_in_slot"])) # 딕셔너리 26번 확인 
	if game_state["dice_in_slot"][slot_name] == dice_name: # slot에 있던 주사위를 도로 놓은 경우
		pass
		
	elif game_state["dice_in_slot"][slot_name] == null: # slot에 있던 주사위가 없을 경우
		game_state["dice_in_slot"][slot_name] = dice_name
		game_state["dice_position"][dice_name] = slot_name
		EventBus.emit_signal("update_slot", slot_name, dice_name, game_state["dice_value"][dice_name])
		
	else: # slot에 다른 주사위가 있었을 경우
		var pre_dice_name = game_state["dice_in_slot"][slot_name] # 들어있던 주사위 이름
		var pre_slot_name = game_state["dice_position"][dice_name] # 새로운 주사위가 있던 슬롯
		print("teleport: ", pre_dice_name, " ", pre_slot_name)
		
		if pre_slot_name == null: 
			pass
		else: # 교환되는 상황
			game_state["dice_in_slot"][pre_slot_name] = pre_dice_name
		game_state["dice_position"][pre_dice_name] = pre_slot_name # 기존 주사위를 빈곳으로 이동
		EventBus.emit_signal("teleport_dice", pre_slot_name, pre_dice_name, game_state["dice_value"][pre_dice_name])
		
		game_state["dice_in_slot"][slot_name] = dice_name
		game_state["dice_position"][dice_name] = slot_name
		EventBus.emit_signal("update_slot", slot_name, dice_name, game_state["dice_value"][dice_name])	
	
func _on_dice_out_of_slot(dice_name, slot_name):
	print(dice_name, " out of slot", slot_name)
	game_state["dice_in_slot"][slot_name] = null # 슬롯 비우기
	game_state["dice_position"][dice_name] = null # 다이스 초기 위치로 
	EventBus.emit_signal("update_slot", slot_name, null, "")	

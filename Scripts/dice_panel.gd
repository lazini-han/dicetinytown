extends Node2D

const DICE_NUMBER = 3

var dice_scene:PackedScene = preload("res://Scenes/dice.tscn")
var positions: Array = []
var dice_list: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	# 주사위들의 초기 위치 지정
	positions = [$Position1.position, $Position2.position, $Position3.position, $Position4.position]
	
	# 버튼 활성화 변경 신호 감지
	Eventbus.connect("button_roll_dice", self, "_on_button_roll_dice")
	Eventbus.connect("button_confirm_dice", self, "_on_button_confirm_dice")
	
	
func _on_Button_Roll_Dice_pressed(): # Roll Dice 버튼 눌림
	if dice_list != []: # 원래 있던 주사위 노드 제거
		for dice in dice_list: 
			dice.queue_free()
		dice_list.clear()
	create_dice()
	Eventbus.emit_signal("state_changed","DICE_FREE")


func _on_Button_Confirm_pressed(): # Confirm 버튼 눌림
	Eventbus.emit_signal("state_changed","READY")


func _on_button_roll_dice(active): # Roll Dice 버튼 활성화 변경
	$ButtonRollDice.disabled = not active


func _on_button_confirm_dice(active): # Confirm 버튼 활성화 변경
	$ButtonConfirm.disabled = not active


func create_dice(): # 주사위를 DICE_NUMBER 만큼 생성하면서 랜덤값과 인덱스 할당
	for index in range(0,DICE_NUMBER):
		print("Creating dice %d at position: %s" % [index, positions[index]])
		
		var new_dice = dice_scene.instance()
		new_dice.position = positions[index] 
		
		# 주사위 속성 설정
		new_dice.input_pickable = true
		
		add_child(new_dice) # 씬 트리에 추가
		dice_list.append(new_dice)
		
		var dice_value = randi() % 6 + 1 # 1-6 랜덤값 결정
		dice_list[index].set_dice(index, dice_value)
		

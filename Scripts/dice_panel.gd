extends Node2D

const DICE_NUMBER = 3
const SLOT_NUMBER = 3
const NUMBERS = 27 # 랜덤 넘버 생성 갯수

var random_numbers: Array = []

var dice_list: Array = []
var ready_positions: Array = []
var positions: Array = []
var slots: Array
var target_slot_index: int

var command_stack = []


# Called when the node enters the scene tree for the first time.
func _ready():
	dice_list = [$Dice1, $Dice2, $Dice3]
	ready_positions = [$ReadyPosition1.position, $ReadyPosition2.position, $ReadyPosition3.position]
	positions = [$Position1.position, $Position2.position, $Position3.position]
	slots = [$SlotShape, $SlotBuilding, $SlotNature]
	
	for index in range(0,DICE_NUMBER):		
		var idice = dice_list[index]
		idice.position = ready_positions[index]
	
	randomize_with_date_seed() # 오늘 날짜를 바탕으로 랠덤 시드 설정
	for i in range(NUMBERS): 
		random_numbers.append(randi() % 6 + 1)
	
	# 버튼 활성화 변경 신호 감지
	Eventbus.connect("ButtonRollDice_change", self, "_on_ButtonRollDice_change")
	Eventbus.connect("ButtonUndo_change", self, "_on_ButtonUndo_change")
	# 주사위 클릭 감지
	Eventbus.connect("clicked_dice", self, "_on_clicked_dice")
	Eventbus.connect("target_slot_update", self, "_on_target_slot_update")


# ------ BUTTONS -------
func _on_ButtonRollDice_pressed():
	roll_dice()
	Eventbus.emit_signal("state_changed","DICE_FREE")


func _on_ButtonUndo_pressed():
	if command_stack.size() > 0:
		var last_command = command_stack.pop_back()
		last_command.undo()  # 가장 최근의 명령 취소
		target_slot_index -= 1
	if command_stack.size() == 0:
		_on_ButtonUndo_change(false) 

func _on_ButtonRollDice_change(active): # Roll Dice 버튼 활성화 변경
	$ButtonRollDice.disabled = not active


func _on_ButtonUndo_change(active): # Undo 버튼 활성화 변경
	$ButtonUndo.disabled = not active


# ------ FUNCTIONS ------
func roll_dice(): 
	for index in range(0,DICE_NUMBER):		
		var idice = dice_list[index]
		idice.position = positions[index] 
		idice.roll_dice(random_numbers) # 주사위 굴리기
		print("dice_panel.gd, roll_dice(), Dice %d Result %d" % [index, idice.dice_value])

	command_stack.clear()
	target_slot_index = 0


# 날짜를 시드로 설정하는 함수
func randomize_with_date_seed():
	var current_date = Time.get_date_dict_from_system()
	var seed_value = current_date["year"] * 10000 + current_date["month"] * 100 + current_date["day"]
	randomize()  # 기본 랜덤화
	seed(seed_value)  # 날짜를 시드로 설정


func _on_clicked_dice(dice):
	for slot in slots:
		if slot.current_dice == dice:
			print("Already occupied dice")
			return
	
	var old_position = dice.global_position
	var new_position = slots[target_slot_index].global_position + slots[target_slot_index].get_node("Sprite").texture.get_size() / 2
	
	var icommand = load("res://Scripts/Commands/command_dice_move.gd").new(dice, old_position, new_position)
	#	var icommand = DiceMoveCommand.new(dice, old_position, new_position)
	icommand.execute()
	command_stack.append(icommand)
	if command_stack.size() > 0 :
		_on_ButtonUndo_change(true) 
	target_slot_index += 1
	
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and not event.pressed:
		print("Right clicked")



		

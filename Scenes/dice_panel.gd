extends Node2D

const DICE_NUMBER = 3
const DICE_SPACING = 10

var dice_scene:PackedScene = preload("res://Scenes/dice.tscn")
var positions: Array = []
var dice_list: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	positions = [$Position_1.position, $Position_2.position, $Position_3.position, $Position_4.position]
	Eventbus.connect("button_roll_dice", self, "_on_button_roll_dice") # 주사위가 굴림 결과 받기
	Eventbus.connect("button_confirm_dice", self, "_on_button_confirm_dice") # 주사위가 굴림 결과 받기
	pass

func _on_Button_Roll_Dice_pressed():
	if(dice_list != []):
		for dice in dice_list: # 원래 있던 주사위 노드 제거
			dice.queue_free()
		dice_list.clear()
	create_dice()
	Eventbus.emit_signal("roll_dice")

func _on_Button_Confirm_pressed():
	Eventbus.emit_signal("confirm_dice")

func _on_button_roll_dice(active):
	$Button_Roll_Dice.disabled = not(active)

func _on_button_confirm_dice(active):
	$Button_Confirm.disabled = not(active)

func create_dice():
	for index in range(0,DICE_NUMBER):
		print("position_",index," : ",positions[index])
		
		var new_dice = dice_scene.instance()
		new_dice.position = positions[index] 
		
		add_child(new_dice)
		dice_list.append(new_dice)
		
		var dice_value = randi() % 6  # 1-6 랜덤값 결정
		dice_list[index].set_dice(index, dice_value)
		

class_name SingleDice
extends Area2D

signal clicked(dice)  

export var dice_value: int
export var dice_index: int # inspector에서 설정
export(Array, Texture) var dice_sprites = []

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():	
	visible = true
	set_dice(0) # 초기 값 0
	connect("input_event", self, "_on_input_event")


func set_dice(value:int): # 할당된 값으로 주사위 값 변경
	dice_value = value
	if value >= 0 and value < dice_sprites.size():
		sprite.texture = dice_sprites[value]
	else:
		print("ERROR: 유효하지 않은 주사위 값 - " + str(value))


func value_up() -> bool:
	if dice_value < 6:
		dice_value += 1
		sprite.texture = dice_sprites[dice_value]
		return true
	return false


func value_down() -> bool:
	if dice_value > 0:
		dice_value -= 1
		sprite.texture = dice_sprites[dice_value]
		return true
	return false


# 마우스 클릭 이벤트 처리
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		emit_signal("clicked", self)
		print("주사위 " + str(dice_index) + " 클릭됨")

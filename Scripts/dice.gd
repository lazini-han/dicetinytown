extends Area2D

const DICE_SCALE = 0.4

var dice_value: int = -1

export var dice_index: int
export(Array, Texture) var dice_sprites = []

onready var sprite = $Sprite
onready var collisionshape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():	
	visible = true

	sprite.texture = dice_sprites[2]
	sprite.scale = Vector2(DICE_SCALE, DICE_SCALE)
	collisionshape2D.scale = Vector2(DICE_SCALE, DICE_SCALE)


func set_dice(index:int, value:int): # 할당된 값으로 주사위 인덱스와 값과 그림 변경
	dice_index = index
	dice_value = value
	sprite.texture = dice_sprites[dice_value]


func value_up(): # 주사위 값을 1 증가시키기, 6이면 정지
	if dice_value < 5:
		dice_value += 1
		sprite.texture = dice_sprites[dice_value]
	else:
		print("%d dice cannot increase" % dice_index)


func value_down(): # 주사위 값을 1 감소시키기, 1이면 정지
	if dice_value > 0:
		dice_value -= 1
		sprite.texture = dice_sprites[dice_value]
	else:
		print("%d dice cannot decrease" % dice_index)


func _on_Dice_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse click pressed %d dice" % dice_index)
		
	elif event is InputEventMouseButton and not event.pressed:
		Eventbus.emit_signal("clicked_dice", self)
		print("Mouse click released %d dice" % dice_index)


func _on_Dice_mouse_entered():
	print("Mouse entered %d dice" % dice_index)


func _on_Dice_mouse_exited():
	print("Mouse exited %d dice" % dice_index)

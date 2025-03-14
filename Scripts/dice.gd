extends Area2D

export var dice_value: int
export var dice_index: int # inspector에서 설정
export(Array, Texture) var dice_sprites = []

onready var sprite = $Sprite
onready var collisionshape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():	
	visible = true
	dice_value = 0
	sprite.texture = dice_sprites[0]
	connect("input_event", self, "_on_input_event")

func set_dice(value:int): # 할당된 값으로 주사위 값 변경
	dice_value = value
	sprite.texture = dice_sprites[dice_value]


func roll_dice(random_numbers:Array):
	if random_numbers == []:
		print("ERROR: dice.gd, roll_dice(), random_numbers is null")
		dice_value = 0
	else:
		dice_value = random_numbers.pop_back() # 랜덤넘버 목록 값으로 주사위 값 변경
	sprite.texture = dice_sprites[dice_value]
	

func value_up(): # 주사위 값을 1 증가시키기, 6이면 정지
	if dice_value < 6:
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


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		#print("Mouse click pressed %d dice" % dice_index)
		pass
		
	elif event is InputEventMouseButton and not event.pressed:
		if event.button_index == BUTTON_LEFT:
			Eventbus.emit_signal("clicked_dice", self)
			print("Mouse click released %d dice" % dice_index)

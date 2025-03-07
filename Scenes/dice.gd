extends Area2D

export(Array, Texture) var dice_sprites = []
export var dice_index: int

var dice_value: int = -1

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false
	visible = true
	sprite.texture = dice_sprites[2]
	sprite.scale = Vector2(0.5, 0.5)

func set_dice(index:int, value:int):
	dice_index = index
	dice_value = value
	sprite.texture = dice_sprites[dice_value]
	
	
	############################################
func value_up(): 
	if dice_value < 5:
		dice_value += 1
		sprite.texture = dice_sprites[dice_value]
		return
	else:
		print("%d dice cannot increase" % [dice_index])

func value_down(): 
	if dice_value > 0:
		dice_value -= 1
		sprite.texture = dice_sprites[dice_value]
		return
	else:
		print("%d dice cannot decrease" % [dice_index])
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

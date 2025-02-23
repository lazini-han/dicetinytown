extends Sprite

export var this_dice: int # 각 Sprite 마다 다른 값 설정
var unselected = 4
	
onready var game = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	game.connect("dice_selected_changed", self, "_update_selected")
	
func _update_selected(new_dice_selected):
	if new_dice_selected == this_dice:
		$Outline.visible = true;
	else:
		$Outline.visible = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var sprite_size = texture.get_size() * scale
		var sprite_rect = Rect2(global_position - (sprite_size * 0.5), sprite_size)
		
		if sprite_rect.has_point(mouse_pos):
			if(get_parent().dice_selected == this_dice):
				get_parent().dice_selected = unselected
			else:
				get_parent().dice_selected = this_dice
		

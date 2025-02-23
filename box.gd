extends Sprite

export var this_box_position: int # 각 Sprite 마다 다른 값 설정
var empty = 3

var unselected = 4 # un select any dice
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var sprite_size = texture.get_size() * scale
		var sprite_rect = Rect2(global_position - (sprite_size * 0.5), sprite_size)
		
		if sprite_rect.has_point(mouse_pos):
			var this_dice = get_parent().dice_selected
			var this_box =  get_parent().box[this_box_position]
			if(this_dice != unselected and this_box == empty):
				var new_position = get_parent().dice_position
				var new_box = get_parent().box
				var init_box = new_position[this_dice]
				
				new_position[this_dice] = this_box_position
				new_box[init_box] = empty
				this_box = this_dice
				get_parent().set_dice_position(new_position)
				
			

extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var sprite_size = texture.get_size() * scale
		var sprite_rect = Rect2(global_position - (sprite_size * 0.5), sprite_size)
		
		if sprite_rect.has_point(mouse_pos):
			var already = $Outline.visible
			if(already == true):
				$Outline.visible = false
				get_parent().get_node("SelectedLabel").text = ""
			else:
				var dice1_outline = get_parent().get_node("Dice1/Outline")
				var dice2_outline = get_parent().get_node("Dice2/Outline")
				var dice3_outline = get_parent().get_node("Dice3/Outline")
				dice1_outline.visible = false
				dice2_outline.visible = false
				dice3_outline.visible = false
				$Outline.visible = true;
				if(self.name == "Dice1"):
					get_parent().get_node("SelectedLabel").text = str(get_parent().dice1)
				elif(self.name == "Dice2"):
					get_parent().get_node("SelectedLabel").text = str(get_parent().dice2)
				elif(self.name == "Dice3"):
					get_parent().get_node("SelectedLabel").text = str(get_parent().dice3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

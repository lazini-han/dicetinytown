extends Area2D


export var grid_position = Vector2()  # 게임판 내 위치 (0,0 ~ 2,2)
export var onboardtile = false
export var state = ""


func _ready():
	pass


func set_state(tile_state):
	state = tile_state
	if state == "empty":
		$Sprite.texture = preload("res://Images/tile_empty.png")
	elif state == "filled":
		$Sprite.texture = preload("res://Images/tile_filled.png")
	elif state == "temp_filled":
		$Sprite.texture = preload("res://Images/tile_filled.png")
	elif state == "cannot":
		$Sprite.texture = preload("res://Images/tile_cannot.png")
	elif state == "not_show":
		$Sprite.texture = null
	else:
		print("tile.gd, set_state, ", state, " state is not defined.")


func _on_mouse_entered():
	yield(get_tree(), "physics_frame")  # 충돌 검사 후 실행
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	Eventbus.emit_signal("mouse_on_tile", grid_position, onboardtile)


func _on_mouse_exited():
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	Eventbus.emit_signal("mouse_off_tile", grid_position, onboardtile)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		#print("Mouse click pressed %d dice" % dice_index)
		pass
		
	elif event is InputEventMouseButton and not event.pressed:
		if event.button_index == BUTTON_LEFT:
			Eventbus.emit_signal("clicked_tile", grid_position, onboardtile)
			print("Mouse click released tile ", grid_position)


extends Area2D

export var grid_position = Vector2()  # 게임판 내 위치 (0,0 ~ 2,2)
export var state = ""

func set_state(tile_state):
	state = tile_state
	if state == "filled":
		$Sprite.texture = preload("res://Images/tile_filled.png")
	elif state == "not_show":
		$Sprite.texture = null

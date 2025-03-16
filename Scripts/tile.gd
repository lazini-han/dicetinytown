extends Area2D

signal mouse_entered_tile(tile)

export var grid_position = Vector2()  # 게임판 내 위치 (0,0 ~ 2,2)


func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _on_mouse_entered():
	yield(get_tree(), "physics_frame")  # 충돌 검사 후 실행
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	Eventbus.emit_signal("mouse_on_tile", grid_position)


func _on_mouse_exited():
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	Eventbus.emit_signal("mouse_off_tile", grid_position)


func set_state(state):
	if state == "empty":
		$Sprite.texture = preload("res://Images/tile_empty.png")
	elif state == "filled":
		$Sprite.texture = preload("res://Images/tile_filled.png")
	else:
		print("tile.gd, set_state, ", state, " state is not defined.")




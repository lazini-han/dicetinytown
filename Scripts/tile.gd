extends Area2D

signal mouse_entered_tile(tile)

export var grid_position = Vector2()  # 게임판 내 위치 (0,0 ~ 2,2)


func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")



func _on_mouse_entered():
	set_state("filled")


func _on_mouse_exited():
	set_state("empty")


func set_state(state):
	if state == "empty":
		$Sprite.texture = preload("res://Images/tile_empty.png")
	else:
		$Sprite.texture = preload("res://Images/tile_filled.png")




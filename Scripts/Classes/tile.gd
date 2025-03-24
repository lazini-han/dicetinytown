# Tile Scene 클래스
extends Area2D

signal clicked_tile(tile)
signal mouse_on_tile(tile)
signal mouse_off_tile(tile)

export var grid_position: Vector2 # 게임판 내 위치 (0,0 ~ 2,2)
export var state: String
export(Dictionary) var tile_sprites = {}

var sprite
var collision

func _ready():
	pass


func set_state(tile_state):
	state = tile_state
	$Sprite.texture = tile_sprites[state]
	

func get_grid():
	return grid_position


func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == BUTTON_LEFT:
			emit_signal("clicked_tile", self)
			print("Mouse click released tile ", grid_position)


func _on_Tile_mouse_entered():
	yield(get_tree(), "physics_frame")  # 충돌 검사 후 실행
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	emit_signal("mouse_on_tile", self)


func _on_Tile_mouse_exited():
	yield(get_tree(), "idle_frame")  # 1프레임후 실행
	emit_signal("mouse_off_tile", self)

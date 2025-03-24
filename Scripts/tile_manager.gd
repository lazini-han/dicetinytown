# Tile Manager
# 타일들 상태를 컨트롤하는 클래스 
class_name TileManager
extends Node

signal selected_tile(tile)
signal board_changed(board)

export var board: Array
export var board_size: Vector2

func _ready():
	pass


# 타일 초기화
func initialize(init_board):
	print("TileManager initialize")
	board = init_board
	var offset = Vector2(700,300) # 임의로 보드판 시작 위치 설정
	
	for j in board.size():
		for i in board[j].size():
			var itile = GameManager.tile_scene.instance()
			add_child(itile)
			itile.connect("clicked_tile", self, "_on_clicked_tile")
			itile.connect("mouse_on_tile", self, "_on_mouse_on_tile")
			itile.connect("mouse_off_tile", self, "_on_mouse_off_tile")
			itile.tile_sprites = GameManager.tile_sprites
			itile.grid_position = Vector2(i,j)
			itile.position = Vector2(i*33, j*33) + offset
			itile.set_state("Empty")

func _on_clicked_tile(tile):
	if tile.state == "Empty":
		emit_signal("selected_tile", tile)


func _on_mouse_on_tile(tile):
	pass


func _off_mouse_on_tile(tile):
	pass

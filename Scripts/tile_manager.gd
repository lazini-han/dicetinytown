# Tile Manager
# 타일들 상태를 컨트롤하는 클래스 
class_name TileManager
extends Node

signal selected_tile(tile)
signal board_changed(board)

export var board: Array

# 외부 객체들
var input_manager
var shape_manager

# 독립 변수
var tiles = []
var shape_tiles = []
var shape_value = 0
var shape_rotation = 0
var shape_flip = 0
var building_value
var nature_value

func _ready():
	GameManager.connect("slot_shape_change", self, "_on_slot_shape_change")
	GameManager.connect("slot_building_change", self, "_on_slot_building_change")
	GameManager.connect("slot_nature_change", self, "_on_slot_nature_change")


# 타일 초기화
func initialize(init_board, InputManager):
	print("TileManager initialize")
	input_manager = InputManager
	shape_manager = load(GameManager.classes["Shapes"]).new()
	
	board = init_board
	var offset = Vector2(700,300) # 임의로 보드판 시작 위치 설정
	
	for j in board.size():
		tiles.append([])
		for i in board[j].size():
			var itile = GameManager.tile_scene.instance()
			add_child(itile)
			itile.connect("clicked_tile", self, "_on_clicked_tile")
			itile.connect("mouse_on_tile", self, "_on_mouse_on_tile")
			itile.connect("mouse_off_tile", self, "_on_mouse_off_tile")
			itile.tile_sprites = GameManager.tile_sprites
			itile.grid_position = Vector2(i,j)
			itile.position = Vector2(i*32, j*32) + offset 
			# board 초기 상태에 따라서 set_state 바꾸기 (나중에)
			itile.set_state("Empty")
			tiles[j].append(itile)

func _on_clicked_tile(tile):
	if input_manager.tile_selectable:
		var selected_tiles = []
		for j in board.size():
			for i in board[j].size():
				if tiles[j][i].state == "Selected":
					selected_tiles.append(tiles[j][i])
		if selected_tiles.size() == shape_tiles.size():
			emit_signal("selected_tile", selected_tiles)


func _on_mouse_on_tile(tile):
	if input_manager.current_state == "SHAPE_PHASE":
		var empty_tiles = []
		var origin = tile.grid_position
		print(origin)
		print(shape_tiles)
		
		for ishape in shape_tiles:
			var x = ishape.x + origin.x
			var y = ishape.y + origin.y
			if x >= 0 and y >= 0 and x < board[0].size() and y < board.size():
				if tiles[y][x].state == "Empty":
					empty_tiles.append(tiles[y][x])
		if empty_tiles.size() == shape_tiles.size():
			for itile in empty_tiles:
				itile.set_state("Selected")
		else:
			for itile in empty_tiles:
				itile.set_state("Cannot")


func _on_mouse_off_tile(tile):
	for j in board.size():
		for i in board[j].size():
			var itile = tiles[j][i]
			if itile.state == "Selected" or itile.state == "Cannot":
				itile.set_state("Empty")


func _on_slot_shape_change(slot_value):
	shape_value = slot_value
	shape_tiles = shape_manager.get_shape(shape_value, shape_rotation, shape_flip)
	

func _on_slot_building_change(slot_value):
	building_value = slot_value


func _on_slot_nature_change(slot_value):
	nature_value = slot_value
	

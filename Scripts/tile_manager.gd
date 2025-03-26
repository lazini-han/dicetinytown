# Tile Manager
# 타일들 상태를 컨트롤하는 클래스 
class_name TileManager
extends Node

signal selected_tile(selected_tiles)
signal board_changed(board)

export var board: Array

# 외부 객체들
var input_manager
var shape_manager

# 독립 변수
const INIT_BOARD = Vector2(700,300) # 임의로 보드판 시작 위치 설정
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
	GameManager.connect("shape_rotation", self, "_on_shape_rotation")
	GameManager.connect("shape_flip", self, "_on_shape_flip")
	
	board = init_board
	var offset = INIT_BOARD
	
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
		if input_manager.current_state == input_manager.State.SHAPE_PHASE:
			var selected_tiles = []
			for j in board.size():
				for i in board[j].size():
					if tiles[j][i].state == "Selected":
						selected_tiles.append(tiles[j][i])
			if selected_tiles.size() == shape_tiles.size():
				emit_signal("selected_tile", selected_tiles)
		else:
			emit_signal("selected_tile", [tile])

func _on_mouse_on_tile(tile):
	var origin = tile.grid_position
	if input_manager.current_state == input_manager.State.BUILDING_PHASE:
		if tile.state == "Filled":
			tile.set_state("Selected")
		return
	elif input_manager.current_state == input_manager.State.NATURE_PHASE:
		return
	elif shape_value > 0:
		var empty_tiles = []
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
			if input_manager.current_state == input_manager.State.DICE_PHASE or input_manager.current_state == input_manager.State.SHAPE_PHASE:
				if itile.state == "Selected" or itile.state == "Cannot":
					itile.set_state("Empty")
			if input_manager.current_state == input_manager.State.BUILDING_PHASE or input_manager.current_state == input_manager.State.NATURE_PHASE:
				if itile.state == "Selected":
					itile.set_state("Filled")


func _on_slot_shape_change(slot_value):
	shape_value = slot_value
	shape_tiles = shape_manager.get_shape(shape_value, shape_rotation, shape_flip)		
	if shape_value > 0:
		GameManager.emit_signal("shape_button_disable", false)
	else:
		GameManager.emit_signal("shape_button_disable", true)


func _on_shape_rotation():
	shape_rotation += 1
	shape_tiles = shape_manager.get_shape(shape_value, shape_rotation, shape_flip)


func _on_shape_flip():
	shape_flip = not shape_flip
	shape_tiles = shape_manager.get_shape(shape_value, shape_rotation, shape_flip)


func _on_slot_building_change(slot_value):
	building_value = slot_value


func _on_slot_nature_change(slot_value):
	nature_value = slot_value
	

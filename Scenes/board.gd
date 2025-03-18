extends Node2D

const TILE_SIZE = 32  # 타일 크기 (픽셀)
const SPACING = 2 # 타일 여백

export var tile_ready = false
export var build_ready = false
export var nature_ready = false

var tile_scene = preload("res://Scenes/tile.tscn")
var tiles = []  # 2D 배열로 관리
var board_size = Vector2(7, 7)
var preview_tiles = []  # 2D 배열로 관리
var preview_size = Vector2(5, 5)

var block = []
var block_type = 0
var block_rotation = 0
var block_flip = false
var tetrominos = TetrominoData.new() 

func _ready():
	Eventbus.connect("tile_ready", self, "_on_tile_ready")
	Eventbus.connect("mouse_on_tile", self, "_on_mouse_on_tile")
	Eventbus.connect("mouse_off_tile", self, "_on_mouse_off_tile")
	Eventbus.connect("shape_selected", self, "_on_shape_selected")
	Eventbus.connect("clicked_tile", self, "_on_clicked_tile")

	# 타일 인스턴스 생성 및 배치
	var board_pos = $ColorRect3.rect_global_position
	for y in range(board_size.y):
		tiles.append([])
		for x in range(board_size.x):
			var tile = tile_scene.instance()
			tile.position = Vector2(x * (TILE_SIZE+SPACING) + board_pos.x, y * (TILE_SIZE+SPACING) + board_pos.y)
			tile.grid_position = Vector2(x, y)
			tile.onboardtile = true
			tile.state = "empty"
			#tile.connect("Tile_mouse_entered", self, "Tile_on_mouse_entered_tile")
			
			add_child(tile)
			tiles[y].append(tile)
	
	# 타일 미리보기 생성 및 배치
	var preview_pos = $ColorRect4.rect_global_position
	for y in range(preview_size.y):
		preview_tiles.append([])
		for x in range(preview_size.x):
			var tile = tile_scene.instance()
			tile.position = Vector2(x * (TILE_SIZE+SPACING) + preview_pos.x, y * (TILE_SIZE+SPACING) + preview_pos.y)
			tile.grid_position = Vector2(x, y)
			#tile.connect("Tile_mouse_entered", self, "Tile_on_mouse_entered_tile")
			tile.set_state("not_show")
			add_child(tile)
			preview_tiles[y].append(tile)


func _on_tile_ready(active):
	tile_ready = active


func _on_shape_selected(shape_type):
	block_type = shape_type
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)		
	show_preview()
	
# Preview Blocks
func _on_mouse_on_tile(grid_position, onboardtile):
	if tile_ready == true and onboardtile:
		var fill_tiles = _find_possible_tiles(grid_position, block, "empty")
		var set = "" # 배치 가능 표시용
		if fill_tiles.size() < block.size(): # 배치 가능 체크 
			set = "cannot"
		elif fill_tiles.size() == block.size(): # 보여주기
			set = "temp_filled"
		for tile in fill_tiles: # 보드에 표시하기
			tiles[tile.y][tile.x].set_state(set)
	

func _on_mouse_off_tile(grid_position, onboardtile):
	if tile_ready == true and onboardtile:
		for y in range(board_size.y):
			for x in range(board_size.x):
				if tiles[y][x].state == "temp_filled":
					tiles[y][x].set_state("empty")
				elif tiles[y][x].state == "cannot":
					tiles[y][x].set_state("empty")


func show_preview():
	for y in range(preview_size.y):
		for x in range(preview_size.x):
			preview_tiles[y][x].set_state("not_show")

	for block_tile in block:
		preview_tiles[block_tile.y+1][block_tile.x+1].set_state("filled")					


# Place the Block
func _on_clicked_tile(grid_position, onboardtile):
	if tile_ready == true and onboardtile:
		print("tile_ready true and board true")
		var fill_tiles = _find_possible_tiles(grid_position, block, "temp_filled")
		print(fill_tiles.size(), " = ", block.size())
		if fill_tiles.size() == block.size():
			var icommand = load("res://Scripts/Commands/command_shape_place.gd").new(tiles, fill_tiles)
			icommand.execute()
			GameManager.command_stack.append(icommand)
			print("Command Shape Place")
			Eventbus.emit_signal("state_changed","BUILDING_PHASE")


func _find_possible_tiles(origin, select_block, state): # state 상태인 tile 뽑아내기
	var found_tiles = []
	for y in range(board_size.y): # 보드에서 블록 위치 뽑아내기
			for x in range(board_size.x):
				for block_tile in select_block:
					if Vector2(x, y) == Vector2(origin.x,origin.y) + block_tile:
						if tiles[y][x].state == state:
							found_tiles.append(Vector2(x,y))
	return found_tiles	


func _on_ButtonRotate_pressed():
	block_rotation = (block_rotation + 1) % 4
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)
	show_preview()


func _on_ButtonFlip_pressed():
	block_flip = not block_flip
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)
	show_preview()



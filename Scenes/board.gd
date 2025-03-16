extends Node2D

const TILE_SIZE = 32  # 타일 크기 (픽셀)
const SPACING = 2 # 타일 여백

export var tile_ready = false
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
	# 타일 인스턴스 생성 및 배치
	var board_pos = $ColorRect3.rect_global_position
	for y in range(board_size.y):
		tiles.append([])
		for x in range(board_size.x):
			var tile = tile_scene.instance()
			tile.position = Vector2(x * (TILE_SIZE+SPACING) + board_pos.x, y * (TILE_SIZE+SPACING) + board_pos.y)
			tile.grid_position = Vector2(x, y)
			#tile.connect("Tile_mouse_entered", self, "Tile_on_mouse_entered_tile")
			
			add_child(tile)
			tiles[y].append(tile)
	
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
	
	Eventbus.connect("tile_ready", self, "_on_tile_ready")
	Eventbus.connect("mouse_on_tile", self, "_on_mouse_on_tile")
	Eventbus.connect("mouse_off_tile", self, "_on_mouse_off_tile")
	Eventbus.connect("shape_selected", self, "_on_shape_selected")


func _on_tile_ready(active):
	tile_ready = active


func _on_shape_selected(shape_type):
	block_type = shape_type
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)		
	show_preview(block)
	
func _on_mouse_on_tile(grid_position):
	if tile_ready == false:
		return
	for y in range(board_size.y):
		for x in range(board_size.x):
			for block_tile in block:
				if Vector2(x, y) == Vector2(grid_position.x,grid_position.y) + block_tile:
					tiles[y][x].set_state("filled")


func _on_mouse_off_tile(grid_position):
	if tile_ready == false:
		return
	for y in range(board_size.y):
		for x in range(board_size.x):
			tiles[y][x].set_state("empty")


func _on_ButtonRotate_pressed():
	block_rotation = (block_rotation + 1) % 4
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)
	show_preview(block)


func _on_ButtonFlip_pressed():
	block_flip = not block_flip
	block = tetrominos.get_tetromino(block_type, block_rotation, block_flip)
	show_preview(block)


func show_preview(block):
	for y in range(preview_size.y):
		for x in range(preview_size.x):
			preview_tiles[y][x].set_state("not_show")
			
	for block_tile in block:
		preview_tiles[block_tile.y][block_tile.x].set_state("filled")					

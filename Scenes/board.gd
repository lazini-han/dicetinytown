extends Node2D

const TILE_SIZE = 32  # 타일 크기 (픽셀)
const SPACING = 2 # 타일 여백

var tile_scene = preload("res://Scenes/tile.tscn")
var tiles = []  # 2D 배열로 관리
var board_size = Vector2(4, 4)



func _ready():
	# 타일 인스턴스 생성 및 배치
	var board_pos = $ColorRect3.rect_global_position
	for y in range(board_size.y):
		tiles.append([])
		for x in range(board_size.x):
			var tile = tile_scene.instance()
			tile.position = Vector2(x * (TILE_SIZE+SPACING) + board_pos.x, y * (TILE_SIZE+SPACING) + board_pos.y)
			tile.grid_position = Vector2(x, y)
			tile.connect("Tile_mouse_entered", self, "Tile_on_mouse_entered_tile")
			
			add_child(tile)
			tiles[y].append(tile)

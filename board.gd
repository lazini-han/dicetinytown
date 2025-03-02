extends Node2D

const GRID_SIZE = 9
const TILE_SIZE = 32
const MARGIN = 2  # 간격 추가


var empty_texture = preload("res://Images/tile_empty.png")
var filled_texture = preload("res://Images/tile_filled.png")
var hover_texture = preload("res://Images/tile_filled.png")

onready var board = self

func _ready():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var tile = TextureRect.new()
			tile.texture = empty_texture
			tile.rect_min_size = Vector2(TILE_SIZE, TILE_SIZE)
			#tile.rect_position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			tile.rect_position = Vector2(x * (TILE_SIZE + MARGIN), y * (TILE_SIZE + MARGIN))

			tile.connect("gui_input", self, "_on_tile_clicked", [tile])
			tile.connect("mouse_entered", self, "_on_tile_hover", [tile])
			tile.connect("mouse_exited", self, "_on_tile_exit", [tile])
			tile.set_meta("filled", false)  # 타일 상태 저장
			board.add_child(tile)

func _on_tile_clicked(event, tile):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if not tile.get_meta("filled"):
			tile.texture = filled_texture
			tile.set_meta("filled", true)  # 상태 변경

func _on_tile_hover(tile):
	if not tile.get_meta("filled"):
		tile.modulate = Color(1, 1, 1, 0.5)  # 반투명 효과

func _on_tile_exit(tile):
	tile.modulate = Color(1, 1, 1, 1)  # 원래 상태로 복구

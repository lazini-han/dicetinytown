tool  # 이걸 추가하면 Editor에서도 실행됨!
extends Node2D

const GRID_SIZE = 9
const TILE_SIZE = 32
const MARGIN = 2

var empty_texture = preload("res://Images/tile_empty.png")
var filled_texture = preload("res://Images/tile_filled.png")
var hover_texture = preload("res://Images/tile_filled.png")


func _ready():
	if Engine.is_editor_hint():
		generate_board()  # Editor에서 보드를 생성
	else:
		generate_board()
		setup_game_logic()  # 실제 게임 로직 실행

# 🛠️ Editor에서 보드를 생성하는 함수
func generate_board():
	for child in get_children():  # 기존의 타일 삭제 (다시 생성할 때 필요)
		child.queue_free()

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var tile = TextureRect.new()
			tile.texture = empty_texture
			tile.rect_min_size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.rect_position = Vector2(
				x * (TILE_SIZE + MARGIN),
				y * (TILE_SIZE + MARGIN)
			)
			add_child(tile)

# 🎮 실제 게임에서 동작할 함수
func setup_game_logic():
	for tile in get_children():
		tile.connect("gui_input", self, "_on_tile_clicked", [tile])
		tile.set_meta("filled", false)  # 타일 상태 저장

func _on_tile_hover(tile):
	if not tile.get_meta("filled"):
		tile.modulate = Color(1, 1, 1, 0.5)  # 반투명 효과

func _on_tile_clicked(event, tile):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if not tile.get_meta("filled"):
			tile.texture = filled_texture
			tile.set_meta("filled", true)  # 상태 변경

extends Area2D
export var this_dice_number: int # 각 Sprite 마다 다른 값 설정

var dragging = false  # 드래그 여부
var drag_offset = Vector2.ZERO  # 마우스 클릭한 위치 오프셋
var sprite = null

func _ready():
	sprite = $Sprite  # 주사위의 Sprite 노드 가져오기
	monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and _is_mouse_over(event.position):
				dragging = true
				drag_offset = global_position - event.position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

# 마우스가 주사위 위에 있는지 확인하는 함수
func _is_mouse_over(mouse_pos):
	var sprite_size = sprite.texture.get_size() * sprite.scale  # 크기 계산
	var sprite_rect = Rect2(global_position - sprite_size / 2, sprite_size)  # 중심 기준 영역 계산
	return sprite_rect.has_point(mouse_pos)

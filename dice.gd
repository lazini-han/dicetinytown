extends Area2D
export var this_dice_number: int # 각 Sprite 마다 다른 값 설정

const DICE_IMAGES = [
	preload("res://Images/dice_1.png"),
	preload("res://Images/dice_2.png"),
	preload("res://Images/dice_3.png"),
	preload("res://Images/dice_4.png"),
	preload("res://Images/dice_5.png"),
	preload("res://Images/dice_6.png")
]

var dragging = false  # 드래그 여부
var drag_offset = Vector2.ZERO  # 마우스 클릭한 위치 오프셋
var sprite = null
var start_position
var collided_area = null  # 충돌한 Area2D
var current_box = null # 현재 상자
var init_positions = []

func _ready():
	sprite = $Sprite  # 주사위의 Sprite 노드 가져오기
	sprite.texture = DICE_IMAGES[0] # 주사위 초기 눈금
	sprite.visible = false # 주사위 초기 감춤
	var nodes = get_tree().get_nodes_in_group("target_group")
	init_positions = [
		get_node("../Box0_Init").position,
		get_node("../Box1_Init").position,
		get_node("../Box2_Init").position
	]
	EventBus.connect("roll_dice", self, "_on_roll_dice")
	randomize()
	
	start_position = global_position
	monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
func _on_roll_dice():
	sprite.visible = true
	var dice_result = randi() % 6 + 1  # 1-6
	print(this_dice_number, " dice rolled", dice_result)
	self.position = init_positions[this_dice_number]
	sprite.texture = DICE_IMAGES[dice_result - 1] # 주사위 초기 눈금
	EventBus.emit_signal("roll_result", this_dice_number, dice_result)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			#마우스 눌림 : 해당 주사위 위에 있는 지 확인 후 드래그 시작
			if _is_mouse_over(event.position):
				dragging = true
				start_position = global_position
				drag_offset = global_position - event.position
				if current_box and current_box.occupied == self:
					current_box.occupied = null  # 주사위가 슬롯을 떠날 준비 (슬롯 비우기)
					current_box = null
		else:
			# 마우스 릴리즈: 실제로 드래그 중요이었을 경우에만 체크
			if dragging:
				dragging = false
				check_drop_position()

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

# 마우스가 주사위 위에 있는지 확인하는 함수
func _is_mouse_over(mouse_pos):
	var sprite_size = sprite.texture.get_size() * sprite.scale  # 크기 계산
	var sprite_rect = Rect2(global_position - sprite_size / 2, sprite_size)  # 중심 기준 영역 계산
	return sprite_rect.has_point(mouse_pos)

func _on_area_entered(area):
	if not area.is_in_group("DiceBox"):
		return # 다이스 박스가 아닌 충돌은 무시
	if area.occupied == null: # 슬롯 비어있는 경우
		collided_area = area  # 충돌한 슬롯 저장

func _on_area_exited(area):
	if collided_area == area:
		collided_area = null  # 충돌했던 슬롯에서 벗어남

func check_drop_position():
	if collided_area and collided_area.occupied == null:  # 충돌한 슬롯이 있을 경우
		global_position = collided_area.global_position  # 슬롯 위치로 이동
		collided_area.occupied = self
		current_box = collided_area
		
		EventBus.emit_signal("dice_in_box", this_dice_number, current_box)
		
	else:
		global_position = init_positions[this_dice_number]
		
		EventBus.emit_signal("dice_out_of_box", this_dice_number)
		

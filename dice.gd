extends Area2D

const scale_init = Vector2(1.0, 1.0)
const scale_picked = Vector2(0.8, 0.8)
const DICE_IMAGES = [
	preload("res://Images/dice_1.png"),
	preload("res://Images/dice_2.png"),
	preload("res://Images/dice_3.png"),
	preload("res://Images/dice_4.png"),
	preload("res://Images/dice_5.png"),
	preload("res://Images/dice_6.png")
]

var dice_name 
var dice_value = null
var dragging = false  # 드래그 여부
var drag_offset = Vector2.ZERO  # 마우스 클릭한 위치 오프셋
var sprite = null
var start_position
var collided_area = null  # 충돌한 Area2D
var current_slot = null # 현재 상자

func _ready():
	dice_name = get_parent().name
	sprite = $Sprite  # 주사위의 Sprite 노드 가져오기
	sprite.texture = DICE_IMAGES[0] # 주사위 초기 눈금
	sprite.visible = false # 주사위 초기 감춤
	EventBus.connect("roll_dice", self, "_on_roll_dice")
	randomize()
	
	start_position = global_position
	monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	EventBus.connect("teleport_dice", self, "_on_teleport_dice")

	
func _on_roll_dice():
	sprite.visible = true # 처음 굴릴때 주사위 등장
	dice_value = randi() % 6 + 1  # 1-6
		
	self.position = get_parent().get_node_or_null("InitBox").position # 주사위 위치 초기화 
	
	sprite.texture = DICE_IMAGES[dice_value - 1] # 주사위 초기 눈금
	EventBus.emit_signal("roll_result", dice_name, dice_value)
	

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			#마우스 눌림 : 해당 주사위 위에 있는 지 확인 후 드래그 시작
			if _is_mouse_over(event.position):
				dragging = true
				scale = scale_picked
				
				start_position = global_position
				drag_offset = global_position - event.position
				#if current_box and current_box.occupied == self:
				#	current_box.occupied = null  # 주사위가 슬롯을 떠날 준비 (슬롯 비우기)
				#	current_box = null
		else:
			# 마우스 릴리즈: 실제로 드래그 중요이었을 경우에만 체크
			if dragging:
				dragging = false
				scale = scale_init
				check_drop_position()

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset

# 마우스가 주사위 위에 있는지 확인하는 함수
#func _is_mouse_over(mouse_pos):
#	var sprite_size = sprite.texture.get_size() * sprite.scale  # 크기 계산
#	var sprite_rect = Rect2(global_position - sprite_size / 2, sprite_size)  # 중심 기준 영역 계산
#	return sprite_rect.has_point(mouse_pos)
#func _is_mouse_over(mouse_pos: Vector2) -> bool:
#	return $CollisionShape2D.shape and $CollisionShape2D.shape.collide_point(mouse_pos)
#func _is_mouse_over(mouse_pos: Vector2) -> bool:
#	return $CollisionShape2D.shape and $CollisionShape2D.get_global_transform().xform_inv(mouse_pos) in $CollisionShape2D.shape.get_rect()

func _is_mouse_over(mouse_pos: Vector2) -> bool:
	# RectangleShape2D 크기 가져오기
	var shape = $CollisionShape2D.shape as RectangleShape2D
	var half_size = shape.extents  # 반 크기 (extents는 절반 크기를 반환)

	# CollisionShape2D의 위치 기준으로 Rect2 생성
	var rect = Rect2(
		$CollisionShape2D.global_position - half_size,  # 좌상단 좌표
		half_size * 2  # 전체 크기
	)

	# 마우스 위치가 이 Rect2 안에 있는지 확인
	return rect.has_point(mouse_pos)


func _on_area_entered(area):
	if not area.is_in_group("DiceBox"):
		return # 다이스 박스가 아닌 충돌은 무시
		
	print("[dice.gd] ", area.name, " Area Enter")
	collided_area = area  # 충돌한 슬롯 저장

func _on_area_exited(area):
	if collided_area == area:
		print("[dice.gd] ", area.name, " Area Exit")
		collided_area = null  # 충돌했던 슬롯에서 벗어남
		

func check_drop_position():
	if collided_area: # 충돌한 슬롯이 있을 경우
		global_position = collided_area.global_position  # 슬롯 위치로 주사위 정렬	
		current_slot = collided_area.name # 현재 들어간 슬롯 이름
		
		print("[dice.gd] ", dice_name, " in ", current_slot)
		EventBus.emit_signal("dice_in_slot", dice_name, current_slot)		
		
	else:
		if current_slot == null: # 초기 위치에서 초기 위치로 돌아가는 경우 
			global_position = get_parent().get_node_or_null("InitBox").global_position
		
		else:	# 슬롯에서 초기 위치로 돌아가는 경우
			global_position = get_parent().get_node_or_null("InitBox").global_position
			EventBus.emit_signal("dice_out_of_slot", dice_name, current_slot)
			current_slot = null
		
func _on_teleport_dice(tele_slot_name, tele_dice_name, tele_dice_value):	
	if tele_dice_name == dice_name:
		if tele_slot_name == null:
			print("[dice.gd] ", tele_slot_name, " = ", null)
			global_position = get_parent().get_node_or_null("InitBox").global_position	
		else:
			print("[dice.gd] ", tele_slot_name, " = ", tele_slot_name)
			current_slot = tele_slot_name
			global_position = get_node("/root/game").get_node(tele_slot_name).global_position
		
		

extends Area2D
var occupied_dice = null

func _ready():
	add_to_group("DiceBox")
	#monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정
	
	EventBus.connect("update_slot", self, "_on_update_slot")
	EventBus.connect("teleport_dice", self, "_on_teleport_dice")

func _on_update_slot(slot_name, dice_name, dice_value):
	print("update_slot: ", slot_name, dice_name, dice_value)
	if slot_name == self.name:
		occupied_dice = dice_name
		EventBus.emit_signal("update_building_label", dice_value)
	
func _on_teleport_dice(slot_name, dice_name, dice_value): # 순간이동해서 들어온 주사위 파악 및 라벨 업데이트
	print("teleport_dice: ", slot_name, dice_name, dice_value)
	if slot_name == self.name:
		occupied_dice = dice_name
		EventBus.emit_signal("update_building_label", dice_value)
	

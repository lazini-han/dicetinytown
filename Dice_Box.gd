extends Area2D
export var this_box_number: int # 각 Sprite 마다 다른 값 설정
var occupied_dice = null
var slot_label = {
	"Slot_Shape": ""
}

func _ready():
	add_to_group("DiceBox")
	#monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정
	#connect("area_entered", self, "_on_area_entered")
	#connect("area_exited", self, "_on_area_exited")
	connect("update_slot", self, "_on_update_slot")
	connect("teleport_dice", self, "_on_teleport_dice")
signal teleport_dice(slot_name, dice_name)


func _on_update_slot(slot_name, dice_name):
	if slot_name == self.name:
		occupied_dice = dice_name
		EventBus.emit_signal("update_label", , game_state["dice_value"])
	pass
	
func _on_teleport_dice():
	pass



#func _on_area_entered(area):
	# 이미 슬롯에 주사위가 할당되어 있다면 preview 업데이트를 하지 않음.
#	if occupied_dice:
	#	return
		
	# 그룹이나 다른 조건을 통해서 충돌한 노드가 실제 주사위인지 확인할 수 있습니다.
#	if not area.has_method("get"):  # 예시 조건; 필요에 따라 수정
#		return

#func _on_area_exited(area):
	# 만약 exiting 하는 주사위가 슬롯에 할당된 주사위라면 label을 초기화합니다.
	#if occupied_dice == area.name:
	#	occupied_dice = null

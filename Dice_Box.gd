extends Area2D
export var this_box_number: int # 각 Sprite 마다 다른 값 설정

onready var label = $Label  # 슬롯의 라벨 가져오기
var occupied = null  # 현재 슬롯에 배치된 주사위

func _ready():
	monitoring = true # 충돌 감지 활성화
	monitorable = true # 다른 노드가 나를 감지 가능하게 설정
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
func _on_area_entered(area):
	print(area.get("this_dice_number"), " in ", this_box_number)
func _on_area_exited(area):
	print(area.get("this_dice_number"), " out of ", this_box_number)
	

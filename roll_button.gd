extends Button

func _ready():
	# 버튼의 내장 pressed 신호를 연결합니다.
	connect("pressed", self, "_on_pressed")
	EventBus.connect("cannot_roll", self, "_on_cannot_roll")
	
func _on_pressed():
	print("RollButton pressed")
	$EffectRolling.play() # 주사위 효과음
	EventBus.emit_signal("roll_dice")  # 주사위들에게 굴리라는 신호 전달

func _on_cannot_roll():
	print("RollButton disable")
	self.disabled = true

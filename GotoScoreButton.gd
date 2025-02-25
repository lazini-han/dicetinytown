extends Button

func _ready():
	# 버튼의 내장 pressed 신호를 연결합니다.
	connect("pressed", self, "_on_pressed")
	EventBus.connect("show_score_button", self, "_on_show_score_button")
	
func _on_pressed():
	print("ScoreButton pressed")
	EventBus.emit_signal("go_to_score")  

func _on_show_score_button():
	print("ScoreButton shows")
	self.visible = true

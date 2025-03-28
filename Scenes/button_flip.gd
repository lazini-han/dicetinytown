extends Button


func _on_ButtonFlip_pressed():
	GameManager.emit_signal("shape_flip")

extends Button


func _on_ButtonRotate_pressed():
	GameManager.emit_signal("shape_rotation")

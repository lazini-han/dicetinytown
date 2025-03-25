extends Button

func _ready():
	pass # Replace with function body.


func _on_ButtonRotate_pressed():
	GameManager.emit_signal("shape_rotation")

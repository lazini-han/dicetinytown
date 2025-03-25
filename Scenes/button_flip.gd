extends Button


func _ready():
	pass # Replace with function body.


func _on_ButtonFlip_pressed():
	GameManager.emit_signal("shape_flip")

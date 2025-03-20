# 모든 버튼, 주사위 클릭, 타일 클릭에 대한 반응
# Undo 기능을 위한 Command Stack 존재

extends Node

signal roll_dice

func _ready():
	pass # Replace with function body.


func _on_BackToMenu_pressed():
	GameManager.scene_change("START_MENU")


func _on_ButtonRollDice_pressed():
	emit_signal("roll_dice")


func _on_ButtonUndo_pressed():
	pass # Replace with function body.

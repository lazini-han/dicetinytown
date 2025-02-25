extends Control

func _ready():
	
	$TotalScore.text = "Final Total: " + str(GameManager.score)


func _on_GotoMenuButton_pressed():
	get_tree().change_scene("res://start_menu.tscn")

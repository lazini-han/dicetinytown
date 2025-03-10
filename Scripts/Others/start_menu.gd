extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/stage_1.tscn")  # Go to Main Scene

func _on_ExitButton_pressed():
	get_tree().quit()  # Close the game

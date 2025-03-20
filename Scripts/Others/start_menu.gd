extends Control

func _on_StartButton_pressed():
	GameManager.game_start()

func _on_ExitButton_pressed():
	GameManager.game_quit()

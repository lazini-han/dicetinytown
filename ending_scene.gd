extends Control

func _ready():
	var results_data = get_tree().get_meta("game_results", null)
	#$TotalScore.text = results_data["rolls"]
	if results_data:
		var rolls = results_data["rolls"]
		var total_sum = 0
		var text_result = ""

		for i in range(rolls.size()):
			text_result += "Round " + str(i + 1) + ": " + str(rolls[i]) + "\n"
			total_sum += rolls[i][3]  # Sum the total from each round

		$ResultLabel.text = text_result
		$TotalScore.text = "Final Total: " + str(total_sum)


func _on_GotoMenuButton_pressed():
	get_tree().change_scene("res://start_menu.tscn")

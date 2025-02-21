extends Node2D

var dice_images = []  # List to store dice images
var roll_count = 0  # Track number of rolls
var max_rolls = 3  # Maximum rolls allowed
var roll_results = []  # Store all three rounds of results

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  # Ensures different random numbers every time
	# Load dice images into the array
	dice_images = [
		load("res://Images/dice-1.256x256.png"),
		load("res://Images/dice-2.256x256.png"),
		load("res://Images/dice-3.256x256.png"),
		load("res://Images/dice-4.256x256.png"),
		load("res://Images/dice-5.256x256.png"),
		load("res://Images/dice-6.256x256.png")
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RollButton_pressed():
	if roll_count < max_rolls:
		var dice1 = randi() % 6  # First dice (1-6)
		var dice2 = randi() % 6  # Second dice (1-6)
		var dice3 = randi() % 6 # Third dice (1-6)
		var total = dice1 + dice2 + dice3 + 3 # Sum of all dice
		# Update dice images
		$Dice1.texture = dice_images[dice1]
		$Dice2.texture = dice_images[dice2]
		$Dice3.texture = dice_images[dice3]
		$SumLabel.text = "Total: " + str(total)
		
		# Store this round's results
		roll_results.append([dice1 + 1, dice2 + 1, dice3 + 1, total])
		roll_count += 1  # Increase roll count
		
		# ✅ Play rolling sound effect
		$EffectRolling.play()
		
		# Check if it's the last roll
		if roll_count == max_rolls:
			$RollButton.disabled = true  # Disable the button
			$GotoScoreButton.visible = true 

func _on_GotoScoreButton_pressed():
	end_game()  # Transition to the ending scene
	
# Function to transition to the ending scene
func end_game():
	var results_data = {
		"rolls": roll_results
	}
	get_tree().call_deferred("set_meta", "game_results", results_data)
	get_tree().change_scene("res://ending_scene.tscn")
	

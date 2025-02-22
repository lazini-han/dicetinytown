extends Node2D

var dice_images = []  # List to store dice images
var roll_count = 0  # Track number of rolls
var max_rolls = 3  # Maximum rolls allowed
var roll_results = []  # Store all three rounds of results
var dice1 = 1
var dice2 = 1
var dice3 = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  # Ensures different random numbers every time
	# Load dice images into the array
	dice_images = [
		load("res://Images/dice_1.png"),
		load("res://Images/dice_2.png"),
		load("res://Images/dice_3.png"),
		load("res://Images/dice_4.png"),
		load("res://Images/dice_5.png"),
		load("res://Images/dice_6.png")
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RollButton_pressed():
	if roll_count < max_rolls:
		dice1 = randi() % 6 + 1  # First dice (1-6)
		dice2 = randi() % 6 + 1 # Second dice (1-6)
		dice3 = randi() % 6 + 1 # Third dice (1-6)
		var total = dice1 + dice2 + dice3 # Sum of all dice
		# Update dice images
		$Dice1.texture = dice_images[dice1-1]
		$Dice2.texture = dice_images[dice2-1]
		$Dice3.texture = dice_images[dice3-1]
		$SumLabel.text = "Total: " + str(total)
		
		# Store this round's results
		roll_results.append([dice1, dice2, dice3, total])
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
	

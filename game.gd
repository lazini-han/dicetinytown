extends Node2D

var dice = []
var box = [0,1,2,3,3,3] # initial position 3=empty box
var dice_images = []  # List to store dice images
var dice_face = [1 , 1,  1]

var unselected = 4 # for dice
var empty = 3 # for box

signal dice_selected_changed(new_dice_selected)
var dice_selected = unselected  setget set_dice_selected # 4: unselected, i: dice[i] selected
func set_dice_selected(value):
	dice_selected = value
	emit_signal("dice_selected_changed", value)

const init_position = [0,1,2]
var positions = []
var dice_position = init_position.duplicate() setget set_dice_position
func set_dice_position(values):
	dice_position = values
	set_dice_selected(unselected)
	for i in range(3):
		dice[i].position = positions[dice_position[i]]
	
var roll_count = 0  # Track number of rolls
var max_rolls = 3  # Maximum rolls allowed
var roll_results = []  # Store all three rounds of results


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()  # Ensures different random numbers every time
	
	dice = [
		get_node("Dice0"),
		get_node("Dice1"),
		get_node("Dice2")
	]
	# Load dice images into the array
	dice_images = [
		load("res://Images/dice_1.png"),
		load("res://Images/dice_2.png"),
		load("res://Images/dice_3.png"),
		load("res://Images/dice_4.png"),
		load("res://Images/dice_5.png"),
		load("res://Images/dice_6.png")
	]
	positions = [
		$Box0.position,
		$Box1.position,
		$Box2.position,
		$Box3.position,
		$Box4.position,
		$Box5.position
	]
	
#func _process(delta):
#	pass


func _on_RollButton_pressed():
	if roll_count < max_rolls:
		# ✅ Play rolling sound effect
		$EffectRolling.play()
		set_dice_selected(unselected)
		set_dice_position(init_position.duplicate())
		
		
		for i in range(3):
			dice_face[i] = randi() % 6 + 1  # First dice (1-6)
			dice[i].texture = dice_images[dice_face[i]-1]
			
		var total = dice_face[0] + dice_face[1] + dice_face[2] # Sum of all dice
		$SumLabel.text = "Total: " + str(total)
		
		# Store this round's results
		roll_results.append([dice_face[0], dice_face[1], dice_face[2], total])
		roll_count += 1  # Increase roll count
		
		
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
	

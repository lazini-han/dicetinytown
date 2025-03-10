extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("clicked_dice", self, "_on_clicked_dice")
	pass # Replace with function body.


func _on_clicked_dice(dice):
	var old_position = dice.global_position
	var new_position = old_position
	new_position.y = new_position.y + 100
	dice.global_position = new_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

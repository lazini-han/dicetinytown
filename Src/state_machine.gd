# 전체 State 관리

extends Node

enum PlayerState { READY, DICE_OFF, DICE_ON, PLACE_BLOCK, PICK_BUILDING, PICK_NATURE, TURN_END }
var player_state = PlayerState.READY


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node2D

var target_slot: Area2D
var command_stack = []
var slots: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("clicked_dice", self, "_on_clicked_dice")
	Eventbus.connect("slot_shape_occupied", self, "_on_slot_shape_occupied")
	Eventbus.connect("slot_building_occupied", self, "_on_slot_building_occupied")
	Eventbus.connect("slot_nature_occupied", self, "_on_slot_nature_occupied")
	
	slots = [$SlotShape, $SlotBuilding, $SlotNature]
	target_slot = $SlotShape

func _on_clicked_dice(dice):
	
	for slot in slots:
		if slot.current_dice == dice:
			print("Already occupied dice")
			return
		
	var old_position = dice.global_position
	var new_position = target_slot.global_position + target_slot.get_node("Sprite").texture.get_size() / 2
	
	var command = DiceMoveCommand.new(dice, old_position, new_position)
	command.execute()
	command_stack.append(command)
	
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and not event.pressed:
		print("Right clicked - UNDO")
		if command_stack.size() > 0:
			var last_command = command_stack.pop_back()
			last_command.undo()  # 가장 최근의 명령 취소


func _on_slot_shape_occupied(dice, occupied):
	if occupied == true:
		target_slot = $SlotBuilding
	elif occupied == false:
		target_slot = $SlotShape
		

func _on_slot_building_occupied(dice, occupied):
	if occupied == true:
		target_slot = $SlotNature
	elif occupied == false:
		target_slot = $SlotBuilding
		
		
func _on_slot_nature_occupied(dice, occupied):
	if occupied == true:
		Eventbus.emit_signal("state_changed","DICE_OCCUPIED")
	elif occupied == false:
		target_slot = $SlotNature
		Eventbus.emit_signal("state_changed","DICE_FREE")


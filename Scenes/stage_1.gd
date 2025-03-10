extends Node2D

var slot_names = [ "Shape", "Building", "Nature"]
var slots = {} # 슬롯 객체
var occupied_slots:Dictionary # 슬롯에 들어간 주사위 객체
var target_slot = null


# Called when the node enters the scene tree for the first time.
func _ready():
	slots["Shape"] = $SlotShape
	slots["Building"] = $SlotBuilding
	slots["Nature"] = $SlotNature
	for islotname in slot_names:
		occupied_slots[slot_names] = null
	
	Eventbus.connect("clicked_dice", self, "_on_clicked_dice")
	Eventbus.connect("change_target_slot", self, "_on_change_target_slot")
	
	pass # Replace with function body.


func _on_clicked_dice(dice):
	for key in occupied_slots.keys():
		if occupied_slots[key] == dice :
			print("Already occupied dice")
			return
		
	var old_position = dice.global_position
	var new_position = slots[target_slot].global_position + slots[target_slot].get_node("Sprite").texture.get_size() / 2
	dice.global_position = new_position
	
	occupied_slots[target_slot] = dice
	var next_number = slot_names.find(target_slot) + 1
	if next_number <= 2:
		target_slot = slot_names[next_number]
	else:
		Eventbus.emit_signal("state_changed","DICE_OCCUPIED")
	

func _on_change_target_slot(slot_name):
	target_slot = slot_name

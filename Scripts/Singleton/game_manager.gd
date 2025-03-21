extends Node

const scenes = {
	"START_MENU" : "res://Scenes/start_menu.tscn",
	"STAGE_1" : "res://Scenes/stage_1.tscn",
}
const classes = {
	"DiceManager" : "res://Classes/dice_manager.gd", # Dice와 Slot 을 컨트롤 하는 클래스
}
var dice_sprites = [
	load("res://Images/dice_0.png"),
	load("res://Images/dice_1.png"),
	load("res://Images/dice_2.png"),
	load("res://Images/dice_3.png"),
	load("res://Images/dice_4.png"),
	load("res://Images/dice_5.png"),
	load("res://Images/dice_6.png"),
]

var current_scene = null


func _ready():
	print("GameManager initialized")


func scene_change(scene_name):
	print("Scene change: ", scene_name)
	current_scene = scene_name
	get_tree().change_scene(scenes[scene_name])  # 씬 변경


func game_start():
	print("Game start")
	
	var scene_name = "STAGE_1" # 나중에 세이브 기능이 생기면 변경할 것
	current_scene = scene_name
	scene_change(scene_name)
	

func game_quit():
	print("Game quit")
	get_tree().quit()  # Close the game


#func goto_menu():
#	get_tree().change_scene(scenes["START_MENU"])  # 씬 변경

extends Node

const scenes = {
	"START_MENU" : "res://Scenes/start_menu.tscn",
	"STAGE" : "res://Scenes/stage.tscn",
}
const classes = {
	"DiceManager" : "res://Scripts/dice_manager.gd", # Dice와 Slot 을 컨트롤 하는 클래스
	"TileManager" : "res://Scripts/tile_manager.gd", # Tile을 컨트롤 하는 클래스
}
var tile_scene = preload("res://Scripts/Classes/tile.tscn") # Tile Scene 사용
var dice_sprites = [
	load("res://Images/dice_0.png"),
	load("res://Images/dice_1.png"),
	load("res://Images/dice_2.png"),
	load("res://Images/dice_3.png"),
	load("res://Images/dice_4.png"),
	load("res://Images/dice_5.png"),
	load("res://Images/dice_6.png"),
]
var tile_sprites = {
	"Empty": load("res://Images/tile_empty.png"),
	"Filled": load("res://Images/tile_filled.png"),
	"Cannot": load("res://Images/tile_cannot.png"),
}

var current_scene = null


func _ready():
	print("GameManager initialized")


func scene_change(scene_name):
	print("Scene change: ", scene_name)
	current_scene = scene_name
	get_tree().change_scene(scenes[scene_name])  # 씬 변경


func game_start():
	print("Game start")
	
	var scene_name = "STAGE" # 나중에 세이브 기능이 생기면 변경할 것
	current_scene = scene_name
	scene_change(scene_name)
	

func game_quit():
	print("Game quit")
	get_tree().quit()  # Close the game


#func goto_menu():
#	get_tree().change_scene(scenes["START_MENU"])  # 씬 변경

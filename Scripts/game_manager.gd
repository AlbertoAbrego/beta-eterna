extends Node2D

@onready var pause_menu = $Pause
@onready var inventory_menu = $Inventory
var player
var onPause = false
var onInventory = false
var player_death = false

func _ready():
	player = get_node("../Player")
	pause_menu.hide()
	inventory_menu.hide()
	
func _input(event):
	if event.is_action_pressed("pause") and !player_death:
		if onInventory:
			inventory_menu._toggle_show_inventory()
			onInventory = false
		else:
			pause_menu._toggle_pause()
			onPause = !onPause
	elif event.is_action_pressed("inventory") and !player_death:
		if !onPause:
			inventory_menu._toggle_show_inventory()
			onInventory = !onInventory

func set_player_death():
	player_death = true

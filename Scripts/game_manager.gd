extends Node2D

@onready var pause_menu = $Pause
@onready var inventory_menu = $Inventory
var player
var onPause = false
var onInventory = false

func _ready():
	player = get_node("../Player")
	pause_menu.hide()
	inventory_menu.hide()

func get_Player():
	return player

func _input(event):
	if event.is_action_pressed("pause"):
		if onInventory:
			inventory_menu._toggle_show_inventory()
			onInventory = false
		else:
			pause_menu._toggle_pause()
			onPause = !onPause
	elif event.is_action_pressed("inventory"):
		if !onPause:
			inventory_menu._toggle_show_inventory()
			onInventory = !onInventory

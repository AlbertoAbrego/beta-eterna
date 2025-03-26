extends Node2D

@onready var pause_menu = $Player/Pause
@onready var inventory = $Player/Inventory

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu._toggle_pause()
	elif event.is_action_pressed("inventory"):
		inventory._toggle_show_inventory()

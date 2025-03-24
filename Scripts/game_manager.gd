extends Node2D

@onready var pause_menu = $Canvas

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu._toggle_pause()

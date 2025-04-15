extends CanvasLayer

@onready var continue_button = $PauseMenu/VBoxContainer/Continue
@onready var exit_button = $PauseMenu/VBoxContainer/Exit
@onready var pause_menu_color_rect = $PauseMenu
@onready var pause_menu_vbox = $PauseMenu/VBoxContainer

func _ready():
	pause_menu_color_rect.size = get_window().size
	pause_menu_vbox.position = Vector2(pause_menu_color_rect.size.x/2 - pause_menu_vbox.size.x/2, pause_menu_color_rect.size.y/2 - pause_menu_vbox.size.y/2)
	hide()

func _toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()

func _on_continue_pressed():
	_toggle_pause()
	get_parent().onPause = false

func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

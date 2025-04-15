extends CanvasLayer

@onready var main_menu_button = $main_menu_button
@onready var play_again_button = $play_again_button

func _ready():
	hide()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_play_again_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	

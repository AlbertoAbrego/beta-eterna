extends CanvasLayer

@onready var continue_button = $PauseMenu/VBoxContainer/Continue
@onready var exit_button = $PauseMenu/VBoxContainer/Exit

func _ready():
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

func _on_exit_pressed():
	get_tree().quit()

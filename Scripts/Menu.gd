extends Control
func _ready():
	$CenterContainer/VBoxContainer/HBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$CenterContainer/VBoxContainer/HBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_quit_pressed():
	get_tree().quit()

extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/play_levels.tscn");

func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/levels.tscn");

func _on_quit_button_pressed() -> void:
	get_tree().quit();

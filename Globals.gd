extends Node2D
var currentLevel;
var gameRunning = false;

static func get_all_files(path: String, file_ext := "", files : Array[String] = []) -> Array[String]:
	var dir : = DirAccess.open(path)
	if file_ext.begins_with("."): # get rid of starting dot if we used, for example ".tscn" instead of "tscn"
		file_ext = file_ext.substr(1,file_ext.length()-1)
	
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				# recursion
				files = get_all_files(dir.get_current_dir() +"/"+ file_name, file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				
				files.append(dir.get_current_dir() +"/"+ file_name)

			file_name = dir.get_next()
	else:
		print("[get_all_files()] An error occurred when trying to access %s." % path)
	return files

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/levels/level1.tscn");

func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/levels.tscn");

func _on_quit_button_pressed() -> void:
	get_tree().quit();

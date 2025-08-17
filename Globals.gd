extends Node2D
var currentLevel;
var currentLevelNum = 0;
var saveLevel = 0;
var gameMode = 0; # 0 = custom, 1 = built-in
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

func save_game():
	print("SAVE GAME: Gamemode: " + str(gameMode) + ", currentLevelNum: " + str(currentLevelNum) + ", saveLevel: " + str(saveLevel));
	if gameMode == 1: # Built-in level
		if currentLevelNum > saveLevel:
			saveLevel = currentLevelNum
			
	var save_game_file = FileAccess.open("user://state.save", FileAccess.WRITE);
	var json_string = JSON.stringify({
		"saveLevel": saveLevel
	});
	save_game_file.store_line(json_string);
	save_game_file.close()
	return true;

func load_game():
	if not FileAccess.file_exists("user://state.save"):
		return false;
	
	var save_game_file = FileAccess.open("user://state.save", FileAccess.READ);
	var json_as_text = save_game_file.get_as_text();
	var level_obj = JSON.parse_string(json_as_text);
	saveLevel = level_obj.saveLevel;
	print("LOAD GAME: Gamemode: " + str(gameMode) + ", currentLevelNum: " + str(currentLevelNum) + ", saveLevel: " + str(saveLevel));
	return true;

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/levels/level1.tscn");

func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/levels.tscn");

func _on_quit_button_pressed() -> void:
	get_tree().quit();
